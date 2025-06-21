import 'package:flutter/foundation.dart';

class Launcher {
  // Launcher collection fields
  String id;
  String codename;
  String name;
  bool online;
  DateTime? lastPingAt;
  DateTime? lastUserPingAt;
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

  bool rocketConnected;
  num rocketBatteryLevel;

  DateTime? lastLaunchAt;

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
    required this.rocketConnected,
    required this.rocketBatteryLevel,
    required this.lastLaunchAt,
    required this.appUserId,
  }) {
    computeStatus(appUserId);
  }

  void computeStatus(String appUserId) {
    if (online) {
      if (currentUserId == "") {
        if (allowedUsersIds.contains(appUserId) || ownerId == appUserId) {
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
    try {
      id = json['id'] as String;
      codename = json['codename'] as String;
      name = json['name'] as String;
      online = json['online'] as bool;
      lastPingAt =
          json['last_ping_at'] != ''
              ? DateTime.parse(json['last_ping_at'] as String)
              : null;
      lastUserPingAt =
          json['last_user_ping_at'] != ''
              ? DateTime.parse(json['last_user_ping_at'] as String)
              : null;
      created = DateTime.parse(json['created'] as String);
      updated = DateTime.parse(json['updated'] as String);
      ownerName = json['expand']['owner']['name'] as String;
      ownerId = json['expand']['owner']['id'] as String;
      manufacturerName = json['expand']['manufacturer']['name'] as String;
      manufacturerId = json['expand']['manufacturer']['id'] as String;
      currentUserId =
          json['current_user'] != ''
              ? json['current_user']['id'] as String
              : '';
      currentUserName =
          json['current_user'] != ''
              ? json['current_user']['name'] as String
              : '';
      allowedUsersIds =
          json['allowed_users'].isNotEmpty
              ? List<String>.from(
                json['expand']['allowed_users'],
              ).map((dynamic user) => user['id'] as String).toList()
              : [];
      allowedUsersNames =
          json['allowed_users'].isNotEmpty
              ? List<String>.from(
                json['expand']['allowed_users'],
              ).map((dynamic user) => user['name'] as String).toList()
              : [];
      loadedRocketsIds =
          json['loaded_rockets'].isNotEmpty
              ? List<String>.from(
                json['expand']['loaded_rockets'],
              ).map((dynamic rocket) => rocket['id'] as String).toList()
              : [];
      loadedRocketsNames =
          json['loaded_rockets'].isNotEmpty
              ? List<String>.from(
                json['expand']['loaded_rockets'],
              ).map((dynamic rocket) => rocket['name'] as String).toList()
              : [];
      rocketConnected = json['rocket_connected'] as bool;
      rocketBatteryLevel = json['rocket_battery_level'] as num;
      lastLaunchAt =
          json['last_launch_at'] != ''
              ? DateTime.parse(json['last_launch_at'] as String)
              : null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating launcher from JSON: $e');
      }
    }

    computeStatus(appUserId);
  }

  void updateLastLaunchAt(String lastLaunchAt) {
    this.lastLaunchAt = DateTime.parse(lastLaunchAt);
  }

  void updateOwner(String ownerId, String ownerName) {
    this.ownerId = ownerId;
    this.ownerName = ownerName;
  }

  void updateManufacturer(String manufacturerId, String manufacturerName) {
    this.manufacturerId = manufacturerId;
    this.manufacturerName = manufacturerName;
  }

  void updateCurrentUser(String currentUserId, String currentUserName) {
    this.currentUserId = currentUserId;
    this.currentUserName = currentUserName;
  }

  void updateAllowedUser(String userId, String userName) {
    if (!allowedUsersIds.contains(userId)) {
      allowedUsersIds.add(userId);
      allowedUsersNames.add(userName);
    } else {
      int index = allowedUsersIds.indexOf(userId);
      allowedUsersNames[index] = userName;
    }
  }

  void removeAllowedUser(String userId) {
    if (allowedUsersIds.contains(userId)) {
      int index = allowedUsersIds.indexOf(userId);
      allowedUsersIds.removeAt(index);
      allowedUsersNames.removeAt(index);
    }
  }

  void updateLoadedRocket(String rocketId, String rocketName) {
    if (!loadedRocketsIds.contains(rocketId)) {
      loadedRocketsIds.add(rocketId);
      loadedRocketsNames.add(rocketName);
    } else {
      int index = loadedRocketsIds.indexOf(rocketId);
      loadedRocketsNames[index] = rocketName;
    }
  }

  void removeLoadedRocket(String rocketId) {
    if (loadedRocketsIds.contains(rocketId)) {
      int index = loadedRocketsIds.indexOf(rocketId);
      loadedRocketsIds.removeAt(index);
      loadedRocketsNames.removeAt(index);
    }
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
      lastPingAt:
          json['last_ping_at'] != ''
              ? DateTime.parse(json['last_ping_at'] as String)
              : null,
      lastUserPingAt:
          json['last_user_ping_at'] != ''
              ? DateTime.parse(json['last_user_ping_at'] as String)
              : null,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
      ownerName: json['expand']['owner']['name'] as String,
      ownerId: json['expand']['owner']['id'] as String,
      manufacturerName: json['expand']['manufacturer']['name'] as String,
      manufacturerId: json['expand']['manufacturer']['id'] as String,
      currentUserId:
          json['current_user'] != ''
              ? json['current_user']['id'] as String
              : '',
      currentUserName:
          json['current_user'] != ''
              ? json['current_user']['name'] as String
              : '',
      allowedUsersIds:
          json['allowed_users'].isNotEmpty
              ? List<String>.from(
                json['expand']['allowed_users'].map((dynamic val) {
                  print(val);
                  return (val['id'].toString());
                }).toList(),
              )
              : [],
      allowedUsersNames:
          json['allowed_users'].isNotEmpty
              ? List<String>.from(
                (json['expand']['allowed_users']).map((dynamic val) {
                  print(val);
                  return (val['name'].toString());
                }).toList(),
              )
              : [],
      loadedRocketsIds:
          json['loaded_rockets'].isNotEmpty
              ? List<String>.from(
                (json['expand']['loaded_rockets'])
                    .map((dynamic rocket) => rocket['id'] as String)
                    .toList(),
              )
              : [],
      loadedRocketsNames:
          json['loaded_rockets'].isNotEmpty
              ? List<String>.from(
                (json['expand']['loaded_rockets'])
                    .map((dynamic rocket) => rocket['name'] as String)
                    .toList(),
              )
              : [],
      rocketConnected: json['rocket_connected'] as bool,
      rocketBatteryLevel: json['rocket_battery_level'] as num,
      lastLaunchAt: lastLaunchAt != '' ? DateTime.parse(lastLaunchAt) : null,
      appUserId: appUserId,
    );
  }
}
