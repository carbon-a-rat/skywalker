import 'package:skywalker/utils.dart';

class Launch {
  String id;
  String rocketId;
  String rocketName;
  String launcherId;
  String launcherName;

  num waterVolumicPercentage;
  num pressure;
  bool flightDataRecorded;

  bool shouldLoad;
  DateTime? startedWaterLoadingAt;
  DateTime? startedAirLoadingAt;
  DateTime? loadedAt;

  bool shouldFire;
  DateTime? firedAt;
  DateTime? landedAt;

  bool shouldCancel;
  DateTime? canceledAt;

  DateTime created;
  DateTime updated;

  Launch({
    required this.id,
    required this.rocketId,
    required this.rocketName,
    required this.launcherId,
    required this.launcherName,
    required this.waterVolumicPercentage,
    required this.pressure,
    required this.flightDataRecorded,
    required this.shouldLoad,
    required this.startedWaterLoadingAt,
    required this.startedAirLoadingAt,
    required this.loadedAt,
    required this.shouldFire,
    required this.firedAt,
    required this.landedAt,
    required this.shouldCancel,
    required this.canceledAt,
    required this.created,
    required this.updated,
  });

  void updateFromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    prettyPrintJson(json);
    rocketId =
        json['rocket'] != '' ? json['expand']['rocket']['id'] as String : '';
    rocketName =
        json['rocket'] != '' ? json['expand']['rocket']['name'] as String : '';
    launcherId =
        json['launcher'] != ''
            ? json['expand']['launcher']['id'] as String
            : '';
    launcherName =
        json['launcher'] != ''
            ? json['expand']['launcher']['name'] as String
            : '';
    waterVolumicPercentage =
        (json['water_volumic_percentage'] as num).toDouble();
    pressure = (json['pressure'] as num).toDouble();
    flightDataRecorded = json['flight_data_recorded'] as bool;
    shouldLoad = json['should_load'] as bool;
    startedWaterLoadingAt =
        json['started_water_loading_at'] != ''
            ? DateTime.parse(json['started_water_loading_at'] as String)
            : null;
    startedAirLoadingAt =
        json['started_air_loading_at'] != ''
            ? DateTime.parse(json['started_air_loading_at'] as String)
            : null;
    loadedAt =
        json['loaded_at'] != ''
            ? DateTime.parse(json['loaded_at'] as String)
            : null;
    shouldFire = json['should_fire'] as bool;
    firedAt =
        json['fired_at'] != ''
            ? DateTime.parse(json['fired_at'] as String)
            : null;
    landedAt =
        json['landed_at'] != ''
            ? DateTime.parse(json['landed_at'] as String)
            : null;
    shouldCancel = json['should_cancel'] as bool;
    canceledAt =
        json['canceled_at'] != ''
            ? DateTime.parse(json['canceled_at'] as String)
            : null;
    created = DateTime.parse(json['created'] as String);
    updated = DateTime.parse(json['updated'] as String);
  }

  void updateRocket(String id, String name) {
    rocketId = id;
    rocketName = name;
  }

  void updateLauncher(String id, String name) {
    launcherId = id;
    launcherName = name;
  }

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      id: json['id'] as String,
      rocketId:
          json['rocket'] != '' ? json['expand']['rocket']['id'] as String : '',
      rocketName:
          json['rocket'] != ''
              ? json['expand']['rocket']['name'] as String
              : '',
      launcherId:
          json['launcher'] != ''
              ? json['expand']['launcher']['id'] as String
              : '',
      launcherName:
          json['launcher'] != ''
              ? json['expand']['launcher']['name'] as String
              : '',
      waterVolumicPercentage:
          (json['water_volumic_percentage'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      flightDataRecorded: json['flight_data_recorded'] as bool,
      shouldLoad: json['should_load'] as bool,
      startedWaterLoadingAt:
          json['started_water_loading_at'] != ''
              ? DateTime.parse(json['started_water_loading_at'] as String)
              : null,
      startedAirLoadingAt:
          json['started_air_loading_at'] != ''
              ? DateTime.parse(json['started_air_loading_at'] as String)
              : null,
      loadedAt:
          json['loaded_at'] != ''
              ? DateTime.parse(json['loaded_at'] as String)
              : null,
      shouldFire: json['should_fire'] as bool,
      firedAt:
          json['fired_at'] != ''
              ? DateTime.parse(json['fired_at'] as String)
              : null,
      landedAt:
          json['landed_at'] != ''
              ? DateTime.parse(json['landed_at'] as String)
              : null,
      shouldCancel: json['should_cancel'] as bool,
      canceledAt:
          json['canceled_at'] != ''
              ? DateTime.parse(json['canceled_at'] as String)
              : null,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );
  }
}
