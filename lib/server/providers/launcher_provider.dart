import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/controllers/launcher_controller.dart';
import 'package:skywalker/server/models/launcher.dart';
import 'package:skywalker/services.dart';

class LauncherProvider extends ChangeNotifier {
  late final LauncherController controller;

  LauncherProvider(String launcherId) {
    // Pass a callback to the controller to notify the provider
    controller = LauncherController(getIt<PocketBase>(), launcherId, () {
      notifyListeners();
    });
  }

  Launcher? get launcher => controller.launcher;
}
