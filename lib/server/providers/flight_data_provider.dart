import 'package:flutter/material.dart';
import 'package:skywalker/server/controllers/flight_data_controller.dart';
import 'package:skywalker/server/controllers/launch_list_controller.dart';
import 'package:skywalker/server/models/flight_data.dart';
import 'package:skywalker/server/models/launch.dart';

class FlightDatasProvider extends ChangeNotifier {
  late final FlightDatasController controller;

  final String key = UniqueKey().toString();

  FlightDatasProvider(String launchId) {
    // Initialize the controller and pass a callback to notify the provider
    controller = FlightDatasController(launchId: launchId);
    controller.registerUpdateCallback(key, () {
      notifyListeners();
    });
    notifyListeners();
  }

  // Getter for the list of launchers
  List<FlightDataPoint> get points => controller.points;
  bool get ready => controller.ready;
  // Fetch the list of launchers manually (if needed)
  Future<void> fetchDatas() async {
    await controller.fetchDatas();
    notifyListeners();
  }

  @override
  void dispose() {
    // Unregister the callback when the provider is disposed
    controller.unregisterUpdateCallback(key);
    super.dispose();
  }
}
