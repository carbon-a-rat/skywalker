class FlightDataPoint {
  String id;
  String launchId;

  num timeRel;
  num accX;
  num accY;
  num accZ;
  num gyroX;
  num gyroY;
  num gyroZ;

  num altitude;
  num pressure;
  num temperature;

  FlightDataPoint({
    required this.id,
    required this.launchId,
    required this.timeRel,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.altitude,
    required this.pressure,
    required this.temperature,
  });

  void updateFromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    launchId = json['launch'] as String;
    timeRel = (json['timeRel'] as num).toDouble();
    accX = (json['accX'] as num).toDouble();
    accY = (json['accY'] as num).toDouble();
    accZ = (json['accZ'] as num).toDouble();
    gyroX = (json['gyroX'] as num).toDouble();
    gyroY = (json['gyroY'] as num).toDouble();
    gyroZ = (json['gyroZ'] as num).toDouble();
    altitude = (json['altitude'] as num).toDouble();
    pressure = (json['pressure'] as num).toDouble();
    temperature = (json['temperature'] as num).toDouble();
  }

  factory FlightDataPoint.fromJson(Map<String, dynamic> json) {
    return FlightDataPoint(
      id: json['id'] as String,
      launchId: json['launch'] as String,
      timeRel: (json['timeRel'] as num).toDouble(),
      accX: (json['accX'] as num).toDouble(),
      accY: (json['accY'] as num).toDouble(),
      accZ: (json['accZ'] as num).toDouble(),
      gyroX: (json['gyroX'] as num).toDouble(),
      gyroY: (json['gyroY'] as num).toDouble(),
      gyroZ: (json['gyroZ'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
    );
  }
}
