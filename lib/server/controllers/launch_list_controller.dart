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
  bool ready = false;
  List<Launch> launches = [];

  // Callback to notify the provider
  Map<String, Function> onLaunchesUpdatedCallbacks = {};

  List<Function> unsubscribeFunctions = [];

  LaunchListController() {
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

  Future<void> subscribeToRocketUpdates() async {
    var func = await pb
        .collection(rocketsCollection)
        .subscribe('*', onRocketUpdate, fields: "name");
    unsubscribeFunctions.add(func);
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

  Future<void> addLaunch(Launch launch) async {
    try {
      final record = await pb
          .collection(launchesCollection)
          .create(body: launch.toJson());
      ;

      // launches.add(Launch.fromJson(record.toJson()));
      // onLaunchesUpdated(); // Notify the provider
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error adding launch: $e');
      }
    }
  }

  void dispose() {
    unsubscribe();
  }
}

final launchListController = LaunchListController();
