import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/launch.dart';
import 'package:skywalker/services.dart';

class LaunchListController {
  final PocketBase pb = getIt<PocketBase>();
  final String launchesCollection = 'launches';
  final String rocketsCollection = 'rockets';
  final String launchersCollection = 'launchers';

  final String toExpand = 'rocket,launcher';

  List<Launch> launches = [];

  // Callback to notify the provider
  Map<String, Function> onLaunchesUpdatedCallbacks = {};

  LaunchListController() {
    fetchLaunches().then((value) {
      if (value) {
        subscribeToUpdates();
      }
    });
  }

  void onLaunchesUpdated() {
    for (var callback in onLaunchesUpdatedCallbacks.values) {
      callback();
    }
  }

  void registerUpdateCallback(String key, Function callback) {
    onLaunchesUpdatedCallbacks[key] = callback;
  }

  void unregisterUpdateCallback(String key) {
    onLaunchesUpdatedCallbacks.remove(key);
  }

  Future<bool> fetchLaunches() async {
    try {
      final records = await pb
          .collection(launchesCollection)
          .getFullList(expand: toExpand);
      launches =
          records.map((record) => Launch.fromJson(record.toJson())).toList();
      onLaunchesUpdated(); // Notify the provider
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching launches: $e');
      }
    }
    return false;
  }

  void subscribeToUpdates() {
    subscribeToLaunchesUpdates();
  }

  void subscribeToLaunchesUpdates() {
    pb.collection(launchesCollection).subscribe('*', onUpdate);
  }

  Future<void> onUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "create") {
      if (event.record != null) {
        launches.add(Launch.fromJson(event.record!.toJson()));
        onLaunchesUpdated(); // Notify the provider
      }
    } else if (event.action == "update") {
      if (event.record != null) {
        final index = launches.indexWhere(
          (launch) => launch.id == event.record!.id,
        );
        if (index != -1) {
          launches[index].updateFromJson(event.record!.toJson());
          onLaunchesUpdated(); // Notify the provider
        }
      }
    } else if (event.action == "delete") {
      launches.removeWhere((launch) => launch.id == event.record!.id);
      onLaunchesUpdated(); // Notify the provider
    }
  }

  void subscribeToRocketUpdates() {
    pb
        .collection(rocketsCollection)
        .subscribe('*', onRocketUpdate, fields: "name");
  }

  Future<void> onRocketUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        final index = launches.indexWhere(
          (launch) => launch.rocketId == event.record!.id,
        );
        if (index != -1) {
          launches[index].rocketName = event.record!.data['name'];
          onLaunchesUpdated(); // Notify the provider
        }
      }
    }
  }

  void subscribeToLauncherUpdates() {
    pb
        .collection(launchersCollection)
        .subscribe('*', onLauncherUpdate, fields: "name");
  }

  Future<void> onLauncherUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        final index = launches.indexWhere(
          (launch) => launch.launcherId == event.record!.id,
        );
        if (index != -1) {
          launches[index].launcherName = event.record!.data['name'];
          onLaunchesUpdated(); // Notify the provider
        }
      }
    }
  }

  void dispose() {
    pb.collection(launchesCollection).unsubscribe('*');
  }
}
