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
    timeRel = (json['time_rel'] as num).toDouble();
    accX = (json['acc_x'] as num).toDouble();
    accY = (json['acc_y'] as num).toDouble();
    accZ = (json['acc_z'] as num).toDouble();
    gyroX = (json['gyro_x'] as num).toDouble();
    gyroY = (json['gyro_y'] as num).toDouble();
    gyroZ = (json['gyro_z'] as num).toDouble();
    altitude = (json['altitude'] as num).toDouble();
    pressure = (json['pressure'] as num).toDouble();
    temperature = (json['temperature'] as num).toDouble();
  }

  factory FlightDataPoint.fromJson(Map<String, dynamic> json) {
    return FlightDataPoint(
      id: json['id'] as String,
      launchId: json['launch'] as String,
      timeRel: (json['time_rel'] as num).toDouble(),
      accX: (json['acc_x'] as num).toDouble(),
      accY: (json['acc_y'] as num).toDouble(),
      accZ: (json['acc_z'] as num).toDouble(),
      gyroX: (json['gyro_x'] as num).toDouble(),
      gyroY: (json['gyro_y'] as num).toDouble(),
      gyroZ: (json['gyro_z'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
    );
  }
}
