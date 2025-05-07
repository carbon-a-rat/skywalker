class AirLoadingDataPoint {
  String id;
  String launcherId;
  num timeRel;
  num pressure;
  num error;
  num command;

  AirLoadingDataPoint({
    required this.id,
    required this.launcherId,
    required this.timeRel,
    required this.pressure,
    required this.error,
    required this.command,
  });

  void updateFromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    launcherId = json['launcher'] as String;
    timeRel = (json['timeRel'] as num).toDouble();
    pressure = (json['pressure'] as num).toDouble();
    error = (json['error'] as num).toDouble();
    command = (json['command'] as num).toDouble();
  }

  factory AirLoadingDataPoint.fromJson(Map<String, dynamic> json) {
    return AirLoadingDataPoint(
      id: json['id'] as String,
      launcherId: json['launcher'] as String,
      timeRel: (json['timeRel'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      error: (json['error'] as num).toDouble(),
      command: (json['command'] as num).toDouble(),
    );
  }
}
