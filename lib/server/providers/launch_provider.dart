import 'package:flutter/material.dart';
import 'package:skywalker/server/controllers/launch_controller.dart';
import 'package:skywalker/server/models/launch.dart';

class LaunchProvider extends ChangeNotifier {
  late final LaunchController controller;

  final String key = UniqueKey().toString();
  final String launchId;
  LaunchProvider(this.launchId) {
    // Initialize the controller and pass a callback to notify the provider
    controller = LaunchController(launchId);
    controller.registerUpdateCallback(key, () {
      notifyListeners();
    });
    notifyListeners();
  }

  // Getter for the list of launchers
  Launch? get launches => controller.launches;
  bool get ready => controller.ready;
  // Fetch the list of launchers manually (if needed)
  Future<void> fetchLaunches() async {
    await controller.fetchLaunches();
    notifyListeners();
  }

  @override
  void dispose() {
    // Unregister the callback when the provider is disposed
    controller.unregisterUpdateCallback(key);
    super.dispose();
  }
}
