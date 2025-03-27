class Rocket {
  String id = "";
  String name = "";
  String manufacturer = "";
  String lastLaunch = "";
  String status = "";

  Rocket({
    this.id = "",
    this.name = "",
    this.manufacturer = "",
    this.lastLaunch = "",
    this.status = "",
  });

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      status: json['status'] ?? "",
      manufacturer: json['manufacturer'] ?? "",
      lastLaunch: json['last_launch'] ?? "",
    );
  }
}
