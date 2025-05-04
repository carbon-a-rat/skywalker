class Launcher {
  // Launcher collection fields
  String id;
  String codename;
  String name;
  bool online;
  DateTime lastPingAt;
  DateTime lastUserPingAt;
  DateTime created;
  DateTime updated;

  // Other data from other collections
  String ownerName;
  String ownerId;

  String manufacturerName;
  String manufacturerId;

  String currentUserId;
  String currentUserName;

  List<String> allowedUsersIds;
  List<String> allowedUsersNames;

  List<String> loadedRocketsIds;
  List<String> loadedRocketsNames;

  DateTime lastLaunchAt;

  // Other fields
  String appUserId;
  String status = "";

  Launcher({
    required this.id,
    required this.codename,
    required this.name,
    required this.online,
    required this.lastPingAt,
    required this.lastUserPingAt,
    required this.created,
    required this.updated,
    required this.ownerName,
    required this.ownerId,
    required this.manufacturerName,
    required this.manufacturerId,
    required this.currentUserId,
    required this.currentUserName,
    required this.allowedUsersIds,
    required this.allowedUsersNames,
    required this.loadedRocketsIds,
    required this.loadedRocketsNames,
    required this.lastLaunchAt,
    required this.appUserId,
  }) {
    computeStatus(appUserId);
  }

  void computeStatus(String appUserId) {
    if (online) {
      if (currentUserId == "") {
        if (allowedUsersIds.contains(appUserId)) {
          status = "available";
        } else {
          status = "unauthorized";
        }
      } else if (currentUserId == appUserId) {
        status = "connected";
      } else {
        status = "busy";
      }
    } else {
      status = "offline";
    }
  }

  void updatefromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    codename = json['codename'] as String;
    name = json['name'] as String;
    online = json['online'] as bool;
    lastPingAt = DateTime.parse(json['last_ping_at'] as String);
    lastUserPingAt = DateTime.parse(json['last_user_ping_at'] as String);
    created = DateTime.parse(json['created'] as String);
    updated = DateTime.parse(json['updated'] as String);
    ownerName = json['owner']['name'] as String;
    ownerId = json['owner']['id'] as String;
    manufacturerName = json['manufacturer']['name'] as String;
    manufacturerId = json['manufacturer']['id'] as String;
    currentUserId = json['current_user']['id'] as String;
    currentUserName = json['current_user']['name'] as String;
    allowedUsersIds =
        List<String>.from(
          json['allowed_users'],
        ).map((dynamic user) => user['id'] as String).toList();
    allowedUsersNames =
        List<String>.from(
          json['allowed_users'],
        ).map((dynamic user) => user['name'] as String).toList();
    loadedRocketsIds =
        List<String>.from(
          json['loaded_rockets'],
        ).map((dynamic rocket) => rocket['id'] as String).toList();
    loadedRocketsNames =
        List<String>.from(
          json['loaded_rockets'],
        ).map((dynamic rocket) => rocket['name'] as String).toList();

    computeStatus(appUserId);
  }

  void updateLastLaunchAt(String lastLaunchAt) {
    this.lastLaunchAt = DateTime.parse(lastLaunchAt);
  }

  factory Launcher.fromJson(
    Map<String, dynamic> json,
    String lastLaunchAt,
    String appUserId,
  ) {
    return Launcher(
      id: json['id'] as String,
      codename: json['codename'] as String,
      name: json['name'] as String,
      online: json['online'] as bool,
      lastPingAt: DateTime.parse(json['last_ping_at'] as String),
      lastUserPingAt: DateTime.parse(json['last_user_ping_at'] as String),
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
      ownerName: json['owner']['name'] as String,
      ownerId: json['owner']['id'] as String,
      manufacturerName: json['manufacturer']['name'] as String,
      manufacturerId: json['manufacturer']['id'] as String,
      currentUserId: json['current_user']['id'] as String,
      currentUserName: json['current_user']['name'] as String,
      allowedUsersIds:
          List<String>.from(
            json['allowed_users'],
          ).map((dynamic user) => user['id'] as String).toList(),
      allowedUsersNames:
          List<String>.from(
            json['allowed_users'],
          ).map((dynamic user) => user['name'] as String).toList(),
      loadedRocketsIds:
          List<String>.from(
            json['loaded_rockets'],
          ).map((dynamic rocket) => rocket['id'] as String).toList(),
      loadedRocketsNames:
          List<String>.from(
            json['loaded_rockets'],
          ).map((dynamic rocket) => rocket['name'] as String).toList(),
      lastLaunchAt: DateTime.parse(lastLaunchAt),
      appUserId: appUserId,
    );
  }
}
