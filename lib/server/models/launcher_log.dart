class LauncherLog {
  String id;
  DateTime timestamp;
  String launcherId;

  String? launchId;

  String level;
  String event;
  String message;
  dynamic data;

  DateTime created;
  DateTime updated;

  LauncherLog({
    required this.id,
    required this.timestamp,
    required this.launcherId,
    required this.launchId,
    required this.level,
    required this.event,
    required this.message,
    required this.data,
    required this.created,
    required this.updated,
  });
  void updateFromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    timestamp = DateTime.parse(json['timestamp'] as String);
    launcherId = json['launcher'] as String;
    launchId = json['launch'] as String;
    level = json['level'] as String;
    event = json['event'] as String;
    message = json['message'] as String;
    data = json['data'] as dynamic;
    created = DateTime.parse(json['created'] as String);
    updated = DateTime.parse(json['updated'] as String);
  }

  factory LauncherLog.fromJson(Map<String, dynamic> json) {
    return LauncherLog(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      launcherId: json['launcher'] as String,
      launchId: json['launch'] as String,
      level: json['level'] as String,
      event: json['event'] as String,
      message: json['message'] as String,
      data: json['data'] as dynamic,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );
  }
}
