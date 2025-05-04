import "package:pocketbase/pocketbase.dart";

// const pb_url = "http://pocketbase.io";
const pbUrl = "http://localhost:8090";
final PocketBase _pb = PocketBase(pbUrl);

class PocketbaseController {
  var loaded = false;
  var loggedIn = false;

  PocketBase get pb => _pb;

  Future<HealthCheck?> status() async {
    return await pb.health.check();
  }

  Future<bool?> logout() async {
    loggedIn = false;
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

    if (pb.authStore.isValid) {
      loggedIn = true;
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

    loggedIn = false;
    return response;
  }
}
