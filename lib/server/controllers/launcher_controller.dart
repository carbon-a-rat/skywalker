import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/launcher.dart';
import 'package:skywalker/services.dart';

class LauncherController {
  final PocketBase pb = getIt<PocketBase>();
  final String launcherCollection = 'launchers';
  final String toExpand =
      'owner,manufacturer,current_user,allowed_users,loaded_rockets';
  final String launcherId;

  final String launchesCollection = 'launches';

  Launcher? launcher;

  bool controlled = false;
  Timer? timer;

  // Callback to notify the provider
  Function onLauncherUpdated = () {};

  LauncherController(this.launcherId, this.onLauncherUpdated) {
    launcher = null;
    fetchLauncher().then((value) {
      if (value != false) {
        subscribeToUpdates();
      }
    });
  }

  Future<bool> fetchLauncher() async {
    try {
      final record = await pb
          .collection(launcherCollection)
          .getOne(launcherId, expand: toExpand);
      final lastLaunchAt = await pb
          .collection(launchesCollection)
          .getList(
            page: 1,
            perPage: 1,
            filter: 'launcher = "$launcherId"',
            sort: '-fired_at',
          )
          .then((res) {
            if (res.items.isNotEmpty) {
              return res.items.first.data['fired_at'];
            }
            return null;
          });

      if (record.data.isNotEmpty) {
        launcher = Launcher.fromJson(
          record.toJson(),
          lastLaunchAt,
          pb.authStore.record!.id,
        );
        onLauncherUpdated(); // Notify the provider
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching launcher: $e');
      }
    }
    return false;
  }

  void subscribeToUpdates() {
    pb
        .collection(launcherCollection)
        .subscribe(launcherId, onUpdate, expand: toExpand);

    pb
        .collection(launchesCollection)
        .subscribe(
          'launcher = "$launcherId"',
          fields: "fired_at",
          onLastLaunchUpdate,
        );
  }

  Future<void> onUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        if (launcher != null) {
          launcher!.updatefromJson(event.record!.toJson());
          onLauncherUpdated(); // Notify the provider
        }
      }
    } else if (event.action == "delete") {
      launcher = null;
      onLauncherUpdated(); // Notify the provider
    }
  }

  Future<void> onLastLaunchUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "create") {
      if (event.record != null) {
        if (event.record!.data['fired_at'] != '') {
          launcher!.updateLastLaunchAt(event.record!.data['fired_at']);
          onLauncherUpdated(); // Notify the provider
        }
      }
    }
  }

  Future<void> controlPing([Timer? t]) async {
    if (launcher != null) {
      pb
          .collection(launcherCollection)
          .update(
            launcher!.id,
            body: {
              'current_user': pb.authStore.record!.id,
              'last_user_ping_at': DateTime.now().toIso8601String(),
            },
          );
    }
  }

  void takeControl() {
    controlPing();
    timer = Timer.periodic(const Duration(seconds: 5), controlPing);
    controlled = true;
  }

  void releaseControl() {
    timer?.cancel();
    timer = null;
    controlled = false;
  }

  void dispose() {
    timer?.cancel();
    timer = null;
    pb.collection(launcherCollection).unsubscribe(launcherId);
    pb.collection(launchesCollection).unsubscribe('launcher = "$launcherId"');
  }
}
