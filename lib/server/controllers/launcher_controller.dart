import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/launcher.dart';

class LauncherController {
  final PocketBase pb;
  final String launcherCollection = 'launchers';
  final String toExpand =
      'owner,manufacturer,current_user,allowed_users,loaded_rockets';
  final String launcherId;

  final String launchesCollection = 'launches';

  Launcher? launcher;

  // Callback to notify the provider
  Function onLauncherUpdated = () {};

  LauncherController(this.pb, this.launcherId, this.onLauncherUpdated) {
    launcher = null;
    getLauncher().then((value) {
      if (value != null) {
        subscribeToUpdates();
      }
    });
  }

  Future<Launcher?> getLauncher() async {
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
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching launcher: $e');
      }
    }
    return null;
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
}
