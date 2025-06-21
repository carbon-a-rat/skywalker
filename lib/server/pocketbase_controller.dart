import "package:pocketbase/pocketbase.dart";
import "package:skywalker/server/models/launcher.dart";

// const pb_url = "http://pocketbase.io";
const pbUrl = "https://deathstar.cyp.sh/";
final PocketBase _pb = PocketBase(pbUrl);

class User {
  final String userId;
  final String name;
  final String email;

  const User({this.userId = "-1", this.name = "", this.email = ""});

  bool isNull() {
    return (userId) == "-1";
  }

  bool isLoggedIn() {
    return true;
  }

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      userId: responseData['id'],
      name: responseData['name'],
      email: responseData['email'],
      //   type: responseData['type'],
      //   token: responseData['access_token'],
      //   renewalToken: responseData['renewal_token']);
    );
  }
}

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

  User? current_user() {
    if (pb.authStore.isValid) {
      var res = User.fromJson(pb.authStore.model.toJson());

      return User(userId: res.userId, name: res.name, email: res.email);
    }
    return null;
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

  Future<List<Launcher>?>? getLauncherList() async {
    final records = await pb.collection('launchers').getFullList();
    if (records.isNotEmpty) {
      return records
          .map((record) => Launcher.fromJson(record.toJson(), "", ""))
          .toList();
    }
    return null;
  }
}
