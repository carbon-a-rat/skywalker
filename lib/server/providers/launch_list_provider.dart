import 'package:flutter/material.dart';
import 'package:skywalker/server/controllers/launch_list_controller.dart';
import 'package:skywalker/server/models/launch.dart';

class LaunchListProvider extends ChangeNotifier {
  late final LaunchListController controller;

  final String key = UniqueKey().toString();

  LaunchListProvider() {
    // Initialize the controller and pass a callback to notify the provider
    controller = launchListController;
    controller.registerUpdateCallback(key, () {
      notifyListeners();
    });
    notifyListeners();
  }

  // Getter for the list of launchers
  List<Launch> get launches => controller.launches;
  bool get ready => controller.ready;
  // Fetch the list of launchers manually (if needed)
  Future<void> fetchLaunches() async {
    await controller.fetchLaunches();
    notifyListeners();
  }

  void addLaunch(Launch launch) {
    controller.addLaunch(launch);
    notifyListeners();
  }

  @override
  void dispose() {
    // Unregister the callback when the provider is disposed
    controller.unregisterUpdateCallback(key);
    super.dispose();
  }
}
