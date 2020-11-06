import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/utils/constants.dart';

class PlayersProvider extends ChangeNotifier {
  PlayersProvider() {
    getPlayers();
  }

  List<Player> _players = [];

  Future<List<Player>> get players async {
    if (_players == null) await getPlayers();
    return _players;
  }

  Future<void> getPlayers() async {
    _players = await fetchPlayers();
    notifyListeners();
  }

  /* CRUD Functions */
  Future<List<Player>> fetchPlayers() async {
    final response = await http.get(Constants.kDbPath + "/players.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData == null) return [];
      final List<Player> temp = responseData.entries
          .map(
            (entry) => Player.fromJson(entry.key, entry.value),
          )
          .toList();
      return temp;
    } else {
      return null;
    }
  }

  void addLocalPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void removeLocalPlayer(pid) {
    _players.removeWhere((player) => player.id == pid);
    notifyListeners();
  }

  void setPlayerPoints(String id, int category, int points) {
    getPlayerById(id).globalCategoryPoints[category] = points;
    notifyListeners();
  }

  void setPlayerTournamentPoints(
      String pid, String tid, int category, int points) {
    getPlayerById(pid).tournamentCategoryPoints[category][tid] = points;
    notifyListeners();
  }

  Future<bool> createPlayer(
      {String name, String club, Backhand backhand, Handed hand}) async {
    final player = Player(
      name: name,
      club: club,
      nationality: "Argentina",
      backhand: backhand,
      handed: hand,
      birth: DateTime(1990, 10, 10),
      profileUrl: "assets/img/ignacio_lauret_profile.png",
      imageUrl: "assets/img/ignacio_lauret_image.png",
      globalCategoryPoints: [0, 0, 0, 0],
      tournamentCategoryPoints: [
        {"default": 0},
        {"default": 0},
        {"default": 0},
        {"default": 0}
      ],
    );
    // Try adding player to DB.
    final response = await http.post(
      Constants.kDbPath + "/players.json",
      body: jsonEncode(player.toJson()),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      player.id = jsonDecode(response.body)["name"];
      addLocalPlayer(player);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePlayer(String pid) async {
    // Try deleting from DB.
    final response =
        await http.delete(Constants.kDbPath + "/players/$pid.json");
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Remove from local memory.
      removeLocalPlayer(pid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addMatchPoints(TournamentMatch match) async {
    await addPointsToPlayer(
        match.pid1, match.firstPlayerPoints, match.category, match.tid);
    return await addPointsToPlayer(
        match.pid2, match.secondPlayerPoints, match.category, match.tid);
  }

  Future<bool> addPointsToPlayer(
      String pid, int points, int category, String tid) async {
    final newPoints = getPlayerPoints(pid, category) + points;
    final newTournamentPoints =
        getPlayerTournamentPoints(pid, tid, category) + points;
    // Try adding points in DB.
    final response = await http.patch(
      Constants.kDbPath + "/players/$pid/points.json",
      body: jsonEncode({"$category": newPoints}),
    );

    if (response.statusCode == 200) {
      // Add points in local memory.
      setPlayerPoints(pid, category, newPoints);
      // try adding points to tournament in DB.
      final response2 = await http.patch(
        Constants.kDbPath + "/players/$pid/tournamentPoints/$category.json",
        body: jsonEncode({"$tid": newTournamentPoints}),
      );
      if (response2.statusCode == 200) {
        setPlayerTournamentPoints(pid, tid, category, newTournamentPoints);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  /* Getters */
  String getPlayerName(String id) {
    return getPlayerById(id).name;
  }

  int getPlayerPoints(String id, int category) {
    return getPlayerById(id).globalCategoryPoints[category];
  }

  int getPlayerTournamentPoints(String pid, String tid, int category) {
    return getPlayerById(pid).getTournamentPointsOfCategory(tid, category);
  }

  String getPlayerImage(String id) {
    return getPlayerById(id).profileUrl;
  }

  Player getPlayerById(String id) {
    return _players.firstWhere((player) => player.id == id);
  }

  /* Ranking */

  Future<List<Player>> getTournamentRanking(String tid, int category) async {
    final playersList = await players;
    playersList.sort(
      (p1, p2) => p2.getTournamentPointsOfCategory(tid, category).compareTo(
            p1.getTournamentPointsOfCategory(tid, category),
          ),
    );
    return playersList;
  }
}
