import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/launch.dart';
import 'package:skywalker/services.dart';

class LaunchController {
  final PocketBase pb = getIt<PocketBase>();
  final String launchesCollection = 'launches';
  final String rocketsCollection = 'rockets';
  final String launchersCollection = 'launchers';

  String filteredId;
  final String toExpand = 'rocket,launcher';
  bool ready = false;
  Launch? launches;

  // Callback to notify the provider
  Map<String, Function> onLaunchesUpdatedCallbacks = {};

  List<Function> unsubscribeFunctions = [];

  LaunchController(this.filteredId) {
    fetchLaunches().then((value) {
      if (value) {
        subscribeToUpdates();
        ready = true;
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
          .getOne(filteredId, expand: toExpand);
      launches = Launch.fromJson(records.toJson());
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

  void unsubscribe() {
    for (var func in unsubscribeFunctions) {
      func();
    }
    unsubscribeFunctions.clear();
  }

  Future<void> subscribeToLaunchesUpdates() async {
    var func = await pb
        .collection(launchesCollection)
        .subscribe('*', onUpdate, expand: toExpand);
    unsubscribeFunctions.add(func);
  }

  Future<void> onUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        if (event.record!.id == filteredId) {
          launches!.updateFromJson(event.record!.toJson());
          onLaunchesUpdated(); // Notify the provider
        }
      }
    } else if (event.action == "delete") {
      launches = null; // Clear the launches if deleted
      onLaunchesUpdated(); // Notify the provider
    }
  }

  void dispose() {
    unsubscribe();
  }
}
