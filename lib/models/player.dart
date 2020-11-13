import 'package:flutter/material.dart';

enum Backhand { OneHanded, TwoHanded }
enum Handed { Right, Left }

class Player {
  Player({
    this.id,
    @required this.name,
    @required this.birth,
    @required this.globalCategoryPoints,
    @required this.tournamentCategoryPoints,
    @required this.nationality,
    @required this.club,
    this.profileUrl,
    this.imageUrl,
    this.backhand = Backhand.TwoHanded,
    this.handed = Handed.Right,
  });

  String id;
  String name;
  final DateTime birth;
  final List<int> globalCategoryPoints; // [points [int]]
  final List<Map<String, int>>
      tournamentCategoryPoints; // [{category [int] : points [int]}]
  final String profileUrl;
  final String imageUrl;
  Backhand backhand;
  Handed handed;
  final String nationality;
  String club;

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
    return globalCategoryPoints[category];
  }

  int getTournamentPointsOfCategory(String tid, int category) {
    if (tournamentCategoryPoints[category].containsKey(tid))
      return tournamentCategoryPoints[category][tid];
    return 0;
  }

  bool playsCategory(int category) {
    return globalCategoryPoints[category] != 0;
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
      globalCategoryPoints: List<int>.from(playerData["points"]),
      tournamentCategoryPoints: List.from(playerData["tournamentPoints"])
          .map((map) => Map<String, int>.from(map))
          .toList(),
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
      "points": globalCategoryPoints,
      "coverUrl": imageUrl,
      "profileUrl": profileUrl,
      "tournamentPoints": tournamentCategoryPoints,
    };
  }
}
