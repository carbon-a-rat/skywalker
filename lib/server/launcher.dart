class Launcher {
  String id = "";
  String name = "";
  String manufacturer = "";
  String lastLaunch = "";
  String status = "";

  Launcher({
    this.id = "",
    this.name = "",
    this.manufacturer = "",
    this.lastLaunch = "",
    this.status = "",
  });

  factory Launcher.fromJson(Map<String, dynamic> json) {
    return Launcher(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      status: json['status'] ?? "",
      manufacturer: json['manufacturer'] ?? "",
      lastLaunch: json['last_launch'] ?? "",
    );
  }
}
