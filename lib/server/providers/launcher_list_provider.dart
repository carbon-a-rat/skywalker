import 'package:flutter/material.dart';
import 'package:skywalker/server/controllers/launcher_list_controller.dart';
import 'package:skywalker/server/models/launcher.dart';

class LauncherListProvider extends ChangeNotifier {
  late final LauncherListController controller;

  LauncherListProvider() {
    // Initialize the controller and pass a callback to notify the provider
    controller = LauncherListController(() {
      notifyListeners();
    });
  }

  // Getter for the list of launchers
  List<Launcher> get launchers => controller.launchers;

  // Fetch the list of launchers manually (if needed)
  Future<void> fetchLaunchers() async {
    await controller.fetchLaunchers();
    notifyListeners();
  }
}
