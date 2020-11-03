class GroupZone {
  String id;
  final String name;
  final List<String> playersIds;
  List<String> matchesIds;
  final int category;
  final String tid;

  GroupZone(
      {this.id,
      this.playersIds,
      this.matchesIds,
      this.category,
      this.name,
      this.tid});

  factory GroupZone.fromJson(String id, Map<String, dynamic> json) {
    return GroupZone(
      id: id,
      name: json["name"],
      category: json["category"],
      playersIds: List<String>.from(json["players"]),
      matchesIds: List<String>.from(json["matches"]),
      tid: json["tid"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "category": this.category,
      "players": this.playersIds,
      "matches": this.matchesIds,
      "tid": this.tid,
    };
  }

  String get categoryName {
    switch (category) {
      case 0:
        return "Platino";
      case 1:
        return "Oro";
      case 2:
        return "Plata";
      case 3:
        return "Bronce";
    }
  }
}
