import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:skywalker/server/models/user.dart';
import 'package:skywalker/services.dart';

class UserController {
  final PocketBase pb = getIt<PocketBase>();
  final String userCollection = 'users';

  User? user;

  // Callback to notify the provider
  Function onUserUpdated = () {};

  List<Function> unsubscribeFunctions = [];

  UserController(String userId, this.onUserUpdated) {
    fetchUser(userId).then((value) {
      if (value != false) {
        subscribeToUpdates(userId);
      }
    });
  }

  Future<bool> fetchUser(String userId) async {
    try {
      final record = await pb.collection(userCollection).getOne(userId);
      if (record.data.isNotEmpty) {
        user = User.fromJson(record.toJson());
        onUserUpdated(); // Notify the provider
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error fetching user: $e');
      }
    }
    return false;
  }

  void unsubscribe() {
    for (var func in unsubscribeFunctions) {
      func();
    }
    unsubscribeFunctions.clear();
  }

  Future<void> subscribeToUpdates(String userId) async {
    var func = await pb.collection(userCollection).subscribe(userId, onUpdate);
    unsubscribeFunctions.add(func);
  }

  Future<void> onUpdate(RecordSubscriptionEvent event) async {
    if (event.action == "update") {
      if (event.record != null) {
        if (user != null) {
          user!.updateFromJson(event.record!.toJson());
          onUserUpdated(); // Notify the provider
        }
      }
    } else if (event.action == "delete") {
      user = null;
      onUserUpdated(); // Notify the provider
    }
  }

  void dispose(String userId) {
    unsubscribe();
  }
}
