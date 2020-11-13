import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/constants.dart';

class TournamentMatch {
  String id;
  String pid1; // Player 1 ID.
  String pid2; // Player 2 ID.
  List<int> result1;
  List<int> result2;
  DateTime date;
  final String tid; // Tournament ID.
  final bool isPlayOff; // If is a play off match or a round match.
  int category;
  final int playOffRound; // If isPLayOff then what round is it.

  TournamentMatch({
    this.id,
    @required this.pid1,
    @required this.pid2,
    @required this.result1,
    @required this.result2,
    @required this.date,
    @required this.tid,
    @required this.isPlayOff,
    @required this.category,
    @required this.playOffRound,
  });

  /* Getters */
  bool get isFirstWinner {
    if (result1 == null) return false;
    return result1.last > result2.last;
  }

  bool get isSecondWinner {
    if (result2 == null) return false;
    return result2.last > result1.last;
  }

  bool get hasEnded {
    return result1 != null;
  }

  String get winnerId {
    return isFirstWinner ? pid1 : pid2;
  }

  int get firstPlayerPoints {
    if (!hasEnded) return 0;
    if (isFirstWinner) return Constants.kLeaguePoints[0];
    if (result1.length == 3) return Constants.kLeaguePoints[1];
    return Constants.kLeaguePoints[2];
  }

  int get secondPlayerPoints {
    if (!hasEnded) return 0;
    if (isSecondWinner) return Constants.kLeaguePoints[0];
    if (result1.length == 3) return Constants.kLeaguePoints[1];
    return Constants.kLeaguePoints[2];
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

  /* Parsers */
  factory TournamentMatch.fromJson(String id, Map<String, dynamic> json) {
    final bool isPlayOff = json["playOffRound"] != null;
    return TournamentMatch(
      id: id,
      pid1: json["pid1"],
      pid2: json["pid2"],
      result1: json["result1"] == null ? null : List<int>.from(json["result1"]),
      result2: json["result2"] == null ? null : List<int>.from(json["result2"]),
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      tid: json["tid"],
      isPlayOff: isPlayOff,
      playOffRound: json["playOffRound"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "pid1": this.pid1,
      "pid2": this.pid2,
      "result1": this.result1,
      "result2": this.result2,
      "date": this.date == null ? null : this.date.toString(),
      "tid": this.tid,
      "category": this.category,
      "playOffRound": this.playOffRound,
    };
  }
}
