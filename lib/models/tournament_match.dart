import 'package:flutter/material.dart';

import '../utils/constants.dart';

class TournamentMatch {
  String id;
  String pid1; // Player 1 ID.
  String pid2; // Player 2 ID.
  List<int> result1;
  List<int> result2;
  int isWo;
  DateTime date;
  final String tid; // Tournament ID.
  final bool isPlayOff; // If is a play off match or a round match.
  int category;
  final int playOffIndex;
  final bool isPredicted;

  TournamentMatch({
    this.id,
    this.pid1,
    this.pid2,
    this.result1,
    this.result2,
    this.isWo = 0, // 0: not WO, 1: WO player 1, 2: WO player 2
    this.date,
    @required this.tid,
    this.isPlayOff,
    @required this.category,
    this.playOffIndex,
    this.isPredicted = false,
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

  int setsWonByPlayer(String pid) {
    if (pid == winnerId) {
      return 2;
    } else {
      return result1.length - 2;
    }
  }

  int setsLostByPlayer(String pid) {
    if (pid == winnerId) {
      return result1.length - 2;
    } else {
      return 2;
    }
  }

  int setsDifferenceOfPlayer(String pid) {
    if (!hasEnded) return 0;
    return setsWonByPlayer(pid) - setsLostByPlayer(pid);
  }

  int gamesWonByPlayer(String pid) {
    if (pid == this.pid1) {
      return result1.fold<int>(
          0, (previousValue, games) => previousValue + games);
    } else if (pid == this.pid2) {
      return result2.fold<int>(
          0, (previousValue, games) => previousValue + games);
    }
    return null;
  }

  int gamesLostByPlayer(String pid) {
    if (pid == this.pid1) {
      return result2.fold<int>(
          0, (previousValue, games) => previousValue + games);
    } else if (pid == this.pid2) {
      return result1.fold<int>(
          0, (previousValue, games) => previousValue + games);
    }
    return null;
  }

  int gamesDifferenceOfPlayer(String pid) {
    if (!hasEnded) return 0;
    return gamesWonByPlayer(pid) - gamesLostByPlayer(pid);
  }

  static String getCategoryName(int category) {
    switch (category) {
      case 0:
        return "Platino";
      case 1:
        return "Oro";
      case 2:
        return "Plata";
      case 3:
        return "Bronce";
      default:
        return null;
    }
  }

  String get categoryName {
    return getCategoryName(this.category);
  }

  /* Parsers */
  factory TournamentMatch.fromJson(String id, Map<String, dynamic> json) {
    final bool isPlayOff = json["playOffIndex"] != null;
    return TournamentMatch(
      id: id,
      pid1: json["pid1"],
      pid2: json["pid2"],
      result1: json["result1"] == null ? null : List<int>.from(json["result1"]),
      result2: json["result2"] == null ? null : List<int>.from(json["result2"]),
      isWo: json["isWo"] == null ? 0 : json["isWo"],
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      tid: json["tid"],
      isPlayOff: isPlayOff,
      playOffIndex: json["playOffIndex"],
      category: json["category"],
      isPredicted: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "pid1": this.pid1,
      "pid2": this.pid2,
      "result1": this.result1,
      "result2": this.result2,
      "isWo": this.isWo,
      "date": this.date == null ? null : this.date.toString(),
      "tid": this.tid,
      "category": this.category,
      "playOffIndex": this.playOffIndex,
    };
  }
}
