import 'package:flutter/material.dart';
import 'package:skywalker/server/controllers/launcher_controller.dart';
import 'package:skywalker/server/models/launcher.dart';

class LauncherProvider extends ChangeNotifier {
  final LauncherController controller;

  LauncherProvider(this.controller) {
    // Pass a callback to the controller to notify the provider
    controller.onLauncherUpdated = notifyListeners;
  }

  Launcher? get launcher => controller.launcher;
}
