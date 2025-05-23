import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/launch.dart';
import 'package:skywalker/services.dart';

class LaunchController {
  final PocketBase pb = getIt<PocketBase>();
  final String launchCollection = 'launches';
  final String rocketsCollection = 'rockets';
  final String launchersCollection = 'launchers';

  Launch? launch;

  // Callback to notify the provider
  Function onLaunchUpdated = () {};
  List<Function> unsubscribeFunctions = [];

  LaunchController(String launchId, this.onLaunchUpdated) {
    fetchLaunch(launchId).then((value) {
      if (value != false) {
        subscribeToUpdates(launchId);
      }
    });
  }

  Future<bool> fetchLaunch(String launchId) async {
    try {
      final record = await pb.collection(launchCollection).getOne(launchId);
      if (record.data.isNotEmpty) {
        launch = Launch.fromJson(record.toJson());
        onLaunchUpdated(); // Notify the provider
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching launch: $e');
      }
    }
    return false;
  }

  void subscribeToUpdates(String launchId) {
    subscribeToLaunchUpdates(launchId);
    subscribeToLaunchersUpdates();
    subscribeToRocketUpdates();
  }

  Future<void> subscribeToLaunchUpdates(String launchId) async {
    var func = pb.collection(launchCollection).subscribe(launchId, onUpdate);
    unsubscribeFunctions.add(await func);
  }

  Future<void> onUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        if (launch != null) {
          launch!.updateFromJson(event.record!.toJson());
          onLaunchUpdated(); // Notify the provider
        }
      }
    } else if (event.action == "delete") {
      launch = null;
      onLaunchUpdated(); // Notify the provider
    }
  }

  Future<void> subscribeToLaunchersUpdates() async {
    var func = pb
        .collection(launchersCollection)
        .subscribe(launch!.launcherId, onLaunchersUpdate, fields: "name");
    unsubscribeFunctions.add(await func);
  }

  void onLaunchersUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        if (launch != null) {
          launch!.updateLauncher(
            event.record!.id,
            event.record!.getStringValue("name"),
          );
          onLaunchUpdated(); // Notify the provider
        }
      }
    }
  }

  Future<void> subscribeToRocketUpdates() async {
    var func = pb
        .collection(rocketsCollection)
        .subscribe(launch!.rocketId, onRocketUpdate, fields: "name");
    unsubscribeFunctions.add(await func);
  }

  void onRocketUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        if (launch != null) {
          launch!.updateRocket(
            event.record!.id,
            event.record!.getStringValue("name"),
          );
          onLaunchUpdated(); // Notify the provider
        }
      }
    }
  }

  void unsubscribe() {
    for (var func in unsubscribeFunctions) {
      func();
    }
    unsubscribeFunctions.clear();
  }

  void dispose(String launchId) {
    unsubscribe();
  }

  void sendCommand(String command) async {
    if (launch != null) {
      switch (command) {
        case "load":
          try {
            await pb
                .collection(launchCollection)
                .update(launch!.id, body: {"should_load": true});
          } catch (e) {
            if (kDebugMode) {
              debugPrint('Error sending load command: $e');
            }
          }
          break;
        case "fire":
          if (launch!.loadedAt != null) {
            try {
              await pb
                  .collection(launchCollection)
                  .update(launch!.id, body: {"should_fire": true});
            } catch (e) {
              if (kDebugMode) {
                debugPrint('Error sending fire command: $e');
              }
            }
          } else {
            throw Exception("Rocket not loaded");
          }
          break;
        case "cancel":
          try {
            await pb
                .collection(launchCollection)
                .update(launch!.id, body: {"should_cancel": true});
          } catch (e) {
            if (kDebugMode) {
              debugPrint('Error sending cancel command: $e');
            }
          }
          break;
        default:
          throw Exception("Unknown command");
      }
    }
  }
}
