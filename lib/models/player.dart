import 'package:flutter/material.dart';

enum Backhand { OneHanded, TwoHanded }
enum Handed { Right, Left }

class Player {
  Player({
    this.id,
    @required this.name,
    @required this.birth,
    @required this.points,
    @required this.nationality,
    @required this.club,
    @required this.bestRankings,
    this.profileUrl,
    this.imageUrl,
    this.backhand = Backhand.TwoHanded,
    this.handed = Handed.Right,
  });

  String id;
  final String name;
  final DateTime birth;
  final List<int> points; // {"category (int)" : points (int)}.
  final String profileUrl;
  final String imageUrl;
  final Backhand backhand;
  final Handed handed;
  final String nationality;
  final String club;
  final List<int> bestRankings; // {"category (int)" : ranking (int)}.

  /* Getters */
  int get age {
    final now = DateTime.now();
    final years = now.year - birth.year;
    if (now.month < birth.month) return years - 1;
    if (now.month == birth.month && now.day < birth.day) return years - 1;
    return years;
  }

  String get backhandType {
    return backhand == Backhand.OneHanded ? "Una mano" : "Dos manos";
  }

  String get hand {
    return handed == Handed.Right ? "Derecha" : "Izquierda";
  }

  int getPointsOfCategory(int category) {
    return points[category];
  }

  bool playsCategory(int category) {
    return points[category] != 0;
  }

  /* Parsers */
  String getParsedHand() {
    return handed == Handed.Right ? "r" : "l";
  }

  int getParsedBackhand() {
    return backhand == Backhand.OneHanded ? 1 : 2;
  }

  static Handed parseHand(String data) {
    return data == "r" ? Handed.Right : Handed.Left;
  }

  static Backhand parseBackhand(int data) {
    return data == 1 ? Backhand.OneHanded : Backhand.TwoHanded;
  }

  factory Player.fromJson(String id, Map<String, dynamic> playerData) {
    return Player(
      id: id,
      name: playerData["name"],
      birth: DateTime.parse(playerData["birth"]),
      nationality: playerData["nationality"],
      club: playerData["club"],
      profileUrl: playerData["profileUrl"],
      imageUrl: playerData["coverUrl"],
      handed: parseHand(playerData["handed"]),
      backhand: parseBackhand(playerData["backhand"]),
      points: List<int>.from(playerData["points"]),
      bestRankings: List<int>.from(playerData["bestRankings"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "club": club,
      "nationality": nationality,
      "backhand": getParsedBackhand(),
      "handed": getParsedHand(),
      "birth": birth.toString(),
      "bestRankings": bestRankings,
      "points": points,
      "coverUrl": imageUrl,
      "profileUrl": profileUrl,
    };
  }
}
