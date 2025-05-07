import 'package:flutter/foundation.dart';

class Rocket {
  String id;
  String name;

  String ownerId;
  String ownerName;
  String manufacturerId;
  String manufacturerName;

  num volume;
  num mass;
  num nozzleDiameter;
  num rocketDiameter;
  num? dragCoefficient;

  DateTime created;
  DateTime updated;

  Rocket({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.ownerName,
    required this.manufacturerId,
    required this.manufacturerName,
    required this.volume,
    required this.mass,
    required this.nozzleDiameter,
    required this.rocketDiameter,
    required this.dragCoefficient,
    required this.created,
    required this.updated,
  });

  void updateFromJson(Map<String, dynamic> json) {
    try {
      name = json['name'] as String;
      ownerId =
          json['owner'] != '' ? json['expand']['owner']['id'] as String : '';
      ownerName =
          json['owner'] != '' ? json['expand']['owner']['name'] as String : '';
      manufacturerId =
          json['manufacturer'] != ''
              ? json['expand']['manufacturer']['id'] as String
              : '';
      manufacturerName =
          json['manufacturer'] != ''
              ? json['expand']['manufacturer']['name'] as String
              : '';
      volume = (json['volume'] as num).toDouble();
      mass = (json['mass'] as num).toDouble();
      nozzleDiameter = (json['nozzleDiameter'] as num).toDouble();
      rocketDiameter = (json['rocketDiameter'] as num).toDouble();
      dragCoefficient = (json['dragCoefficient'] as num?)?.toDouble();
      created = DateTime.parse(json['created'] as String);
      updated = DateTime.parse(json['updated'] as String);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error updating rocket: $e');
      }
    }
  }

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId:
          json['owner'] != '' ? json['expand']['owner']['id'] as String : '',
      ownerName:
          json['owner'] != '' ? json['expand']['owner']['name'] as String : '',
      manufacturerId:
          json['manufacturer'] != ''
              ? json['expand']['manufacturer']['id'] as String
              : '',
      manufacturerName:
          json['manufacturer'] != ''
              ? json['expand']['manufacturer']['name'] as String
              : '',
      volume: (json['volume'] as num).toDouble(),
      mass: (json['mass'] as num).toDouble(),
      nozzleDiameter: (json['nozzleDiameter'] as num).toDouble(),
      rocketDiameter: (json['rocketDiameter'] as num).toDouble(),
      dragCoefficient: (json['dragCoefficient'] as num?)?.toDouble(),
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );
  }
}
