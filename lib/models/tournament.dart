import 'package:flutter/material.dart';

class Tournament {
  String id;
  String name;
  final DateTime startDate;

  Tournament({this.id, @required this.name, @required this.startDate});

  factory Tournament.fromJson(String id, Map<String, dynamic> json) {
    return Tournament(
      id: id,
      name: json["name"],
      startDate: DateTime.parse(json["start"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "start": this.startDate.toString(),
    };
  }
}
