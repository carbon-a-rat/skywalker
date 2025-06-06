class User {
  String id;
  String name;
  String email;

  DateTime created;
  DateTime updated;

  void updatefromJson(dynamic json) {
    id = json['id'] as String;
    name = json['name'] as String;
    email = json['email'] as String;
    created = DateTime.parse(json['created'] as String);
    updated = DateTime.parse(json['updated'] as String);
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.created,
    required this.updated,
  });

  void updateFromJson(Map<String, dynamic> json) {
    id = json['id'] as String;
    name = json['name'] as String;
    email = json['email'] as String;
    created = DateTime.parse(json['created'] as String);
    updated = DateTime.parse(json['updated'] as String);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      created: DateTime.parse(json['created'] as String),
      updated: DateTime.parse(json['updated'] as String),
    );
  }
}
