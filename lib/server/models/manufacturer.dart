class Manufacturer {
  String id;
  String name;
  DateTime created;
  DateTime updated;

  Manufacturer({
    required this.id,
    required this.name,
    required this.created,
    required this.updated,
  });

  void updatefromJson(dynamic json) {
    id = json['id'] as String;
    name = json['name'] as String;
    created = DateTime.parse(json['created'] as String);
    updated = DateTime.parse(json['updated'] as String);
  }

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json['id'] as String,
      name: json['name'] as String,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );
  }
}
