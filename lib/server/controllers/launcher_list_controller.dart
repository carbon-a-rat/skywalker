import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/launcher.dart';
import 'package:skywalker/services.dart';

class LauncherListController {
  final PocketBase pb = getIt<PocketBase>();
  final String launcherCollection = 'launchers';
  final String launchesCollection = 'launches';
  final String toExpand =
      'owner,manufacturer,current_user,allowed_users,loaded_rockets';

  List<Launcher> launchers = [];

  // Callback to notify the provider
  Function onLaunchersUpdated = () {};

  LauncherListController(this.onLaunchersUpdated) {
    fetchLaunchers().then((_) {
      subscribeToUpdates();
    });
  }

  // Fetch the list of launchers, including the last launch property
  Future<void> fetchLaunchers() async {
    try {
      final records = await pb
          .collection(launcherCollection)
          .getFullList(expand: toExpand);

      // Fetch the last launch for each launcher
      launchers = await Future.wait(
        records.map((record) async {
          final lastLaunchAt = await _fetchLastLaunch(record.id);
          return Launcher.fromJson(
            record.toJson(),
            lastLaunchAt,
            pb.authStore.record!.id,
          );
        }),
      );

      onLaunchersUpdated(); // Notify the provider
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching launchers: $e');
      }
    }
  }

  // Fetch the last launch date for a specific launcher
  Future<String> _fetchLastLaunch(String launcherId) async {
    try {
      final result = await pb
          .collection(launchesCollection)
          .getList(
            page: 1,
            perPage: 1,
            filter: 'launcher = "$launcherId"',
            sort: '-fired_at',
          );

      if (result.items.isNotEmpty) {
        return result.items.first.data['fired_at'];
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching last launch for launcher $launcherId: $e');
      }
    }
    return "";
  }

  // Subscribe to real-time updates for the launcher list
  void subscribeToUpdates() {
    pb.collection(launcherCollection).subscribe('*', (event) async {
      if (event.action == "create" && event.record != null) {
        // Add a new launcher
        final lastLaunchAt = await _fetchLastLaunch(event.record!.id);
        final newLauncher = Launcher.fromJson(
          event.record!.toJson(),
          lastLaunchAt,
          pb.authStore.record!.id,
        );
        launchers.add(newLauncher);
        onLaunchersUpdated(); // Notify the provider
      } else if (event.action == "update" && event.record != null) {
        // Update an existing launcher
        final lastLaunchAt = await _fetchLastLaunch(event.record!.id);
        final updatedLauncher = Launcher.fromJson(
          event.record!.toJson(),
          lastLaunchAt,
          pb.authStore.record!.id,
        );
        final index = launchers.indexWhere(
          (launcher) => launcher.id == updatedLauncher.id,
        );
        if (index != -1) {
          launchers[index] = updatedLauncher;
          onLaunchersUpdated(); // Notify the provider
        }
      } else if (event.action == "delete" && event.record != null) {
        // Remove a launcher
        launchers.removeWhere((launcher) => launcher.id == event.record!.id);
        onLaunchersUpdated(); // Notify the provider
      }
    });

    // Subscribe to updates for the launches collection to track last launch changes
    pb.collection(launchesCollection).subscribe('*', (event) async {
      if (event.action == "create" && event.record != null) {
        final launcherId = event.record!.data['launcher'];
        final lastLaunchAt =
            event.record!.data['fired_at'] != null
                ? DateTime.parse(event.record!.data['fired_at'])
                : null;

        final index = launchers.indexWhere(
          (launcher) => launcher.id == launcherId,
        );
        if (index != -1 && lastLaunchAt != null) {
          launchers[index].lastLaunchAt = lastLaunchAt;
          onLaunchersUpdated(); // Notify the provider
        }
      }
    }, fields: "fired_at,launcher");
  }
}
