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

  void subscribeToLaunchUpdates(String launchId) {
    pb.collection(launchCollection).subscribe(launchId, onUpdate);
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

  void subscribeToLaunchersUpdates() {
    pb
        .collection(launchersCollection)
        .subscribe(launch!.launcherId, onLaunchersUpdate, fields: "name");
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

  void subscribeToRocketUpdates() {
    pb
        .collection(rocketsCollection)
        .subscribe(launch!.rocketId, onRocketUpdate, fields: "name");
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

  void dispose(String launchId) {
    pb.collection(launchCollection).unsubscribe(launchId);
  }
}
