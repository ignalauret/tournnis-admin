class Tournament {
  String id;
  final String name;

  Tournament(this.id, this.name);

  factory Tournament.fromJson(String id, Map<String, dynamic> json) {
    return Tournament(id, json["name"]);
  }
}
