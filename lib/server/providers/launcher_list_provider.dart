import 'package:flutter/material.dart';
import 'package:skywalker/server/controllers/launcher_list_controller.dart';
import 'package:skywalker/server/models/launcher.dart';

class LauncherListProvider extends ChangeNotifier {
  late final LauncherListController controller;

  final String key = UniqueKey().toString();

  LauncherListProvider() {
    // Initialize the controller and pass a callback to notify the provider
    controller = launcherListController;
    controller.registerUpdateCallback(key, () {
      notifyListeners();
    });
    notifyListeners();
  }

  // Getter for the list of launchers
  List<Launcher> get launchers => controller.launchers;
  bool get ready => controller.ready;

  // Fetch the list of launchers manually (if needed)
  Future<void> fetchLaunchers() async {
    await controller.fetchLaunchers();
    notifyListeners();
  }

  @override
  void dispose() {
    // Unregister the callback when the provider is disposed
    controller.unregisterUpdateCallback(key);
    super.dispose();
  }
}
