import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/flight_data.dart';
import 'package:skywalker/server/models/launch.dart';
import 'package:skywalker/services.dart';

class FlightDatasController {
  final PocketBase pb = getIt<PocketBase>();
  final String flightDatasCollection = 'flight_data';

  bool ready = false;
  List<FlightDataPoint> points = [];

  // Callback to notify the provider
  Map<String, Function> onFlightDataUpdatedCallbacks = {};

  List<Function> unsubscribeFunctions = [];

  String launchId = '';

  FlightDatasController({required this.launchId}) {
    fetchDatas().then((value) {
      if (value) {
        subscribeToUpdates();
        ready = true;
      }
    });
  }

  void onFlightDatasUpdated() {
    for (var callback in onFlightDataUpdatedCallbacks.values) {
      callback();
    }
  }

  void registerUpdateCallback(String key, Function callback) {
    onFlightDataUpdatedCallbacks[key] = callback;
  }

  void unregisterUpdateCallback(String key) {
    onFlightDataUpdatedCallbacks.remove(key);
  }

  Future<bool> fetchDatas() async {
    final records = await pb
        .collection(flightDatasCollection)
        .getFullList(filter: 'launch="$launchId"');
    points =
        records
            .map((record) => FlightDataPoint.fromJson(record.toJson()))
            .toList();
    onFlightDatasUpdated(); // Notify the provider
    return true;
  }

  void subscribeToUpdates() {
    subscribeToFlightUpdates();
  }

  void unsubscribe() {
    for (var func in unsubscribeFunctions) {
      func();
    }
    unsubscribeFunctions.clear();
  }

  Future<void> subscribeToFlightUpdates() async {
    var func = await pb
        .collection(flightDatasCollection)
        .subscribe('*', onUpdate, filter: 'launch="$launchId"');
    unsubscribeFunctions.add(func);
  }

  Future<void> onUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "create") {
      if (event.record != null) {
        points.add(FlightDataPoint.fromJson(event.record!.toJson()));
        onFlightDatasUpdated(); // Notify the provider
      }
    } else if (event.action == "update") {
      if (event.record != null) {
        final index = points.indexWhere(
          (launch) => launch.id == event.record!.id,
        );

        if (index != -1) {
          points[index].updateFromJson(event.record!.toJson());
          onFlightDatasUpdated(); // Notify the provider
        }
      }
    } else if (event.action == "delete") {
      points.removeWhere((launch) => launch.id == event.record!.id);
      onFlightDatasUpdated(); // Notify the provider
    }
  }

  void dispose() {
    unsubscribe();
  }
}
