import "dart:io";

import "package:pocketbase/pocketbase.dart";
import "package:skywalker/server/launcher.dart";

// const pb_url = "http://pocketbase.io";
const pb_url = "http://localhost:8090";
PocketBase pb = new PocketBase(pb_url);

class PocketbaseController {
  var loaded = false;
  var logged_in = false;

  Future<HealthCheck?> status() async {
    return await pb.health.check();
  }

  Future<bool?> logout() async {
    logged_in = false;
    pb.authStore.clear(); // clear auth data
    return true;
  }

  Future init() async {
    if (loaded) {
      return;
    }
    // code ici pour gérer dans le future le stockage des clés d'authentification en local afin
    // de ne pas devoir à chaque fois les retaper
    loaded = true;
  }

  Future<RecordModel?> login(String email, String password) async {
    var res = await pb.collection('users').authWithPassword(email, password);

    if (res != null) {
      logged_in = true;
    }
    return res.record;
  }

  Future<RecordModel?> register(
    String username,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    var response = await pb
        .collection('users')
        .create(
          body: {
            'name': username,
            'email': email,
            'password': password,
            'passwordConfirm': passwordConfirm,
          },
        );

    logged_in = false;
    return response;
  }

  Future<List<Launcher>?>? get_rocket_list() async {
    final records = await pb.collection('rockets').getFullList();
    if (records != null) {
      return records
          .map((record) => Launcher.fromJson(record.toJson()))
          .toList();
    }
    return null;
  }
}
