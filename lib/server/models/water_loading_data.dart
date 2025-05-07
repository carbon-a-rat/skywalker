class WaterLoadingDataPoint {
  String id;
  String launchId;

  num timeRel;
  num volume;
  num error;
  num command;

  WaterLoadingDataPoint({
    required this.id,
    required this.launchId,
    required this.timeRel,
    required this.volume,
    required this.error,
    required this.command,
  });

  void updateFromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    launchId = json['launch'] as String;
    timeRel = (json['timeRel'] as num).toDouble();
    volume = (json['volume'] as num).toDouble();
    error = (json['error'] as num).toDouble();
    command = (json['command'] as num).toDouble();
  }

  factory WaterLoadingDataPoint.fromJson(Map<String, dynamic> json) {
    return WaterLoadingDataPoint(
      id: json['id'] as String,
      launchId: json['launch'] as String,
      timeRel: (json['timeRel'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      error: (json['error'] as num).toDouble(),
      command: (json['command'] as num).toDouble(),
    );
  }
}
