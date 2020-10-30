import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/utils/constants.dart';

class PlayersProvider extends ChangeNotifier {
  PlayersProvider() {
    getPlayers();
  }

  List<Player> _players = [];
  // Create new player variables
  String newPlayerName;
  String newPlayerClub;
  String newPlayerNationality;
  DateTime newPlayerBirth;
  String newPlayerImageUrl;
  bool newPlayerRightHanded;
  bool newPlayerOneHanded;

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

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void removePlayer(pid) {
    _players.removeWhere((player) => player.id == pid);
    notifyListeners();
  }

  void setPlayerPoints(String id, int category, int points) {
    getPlayerById(id).points[category] = points;
    notifyListeners();
  }

  Future<bool> createPlayer() async {
    final player = Player(
      name: newPlayerName,
      club: newPlayerClub,
      nationality: newPlayerNationality,
      backhand: newPlayerOneHanded ? Backhand.OneHanded : Backhand.TwoHanded,
      handed: newPlayerRightHanded ? Handed.Right : Handed.Left,
      birth: newPlayerBirth,
      profileUrl: "assets/img/ignacio_lauret_profile.png",
      imageUrl: "assets/img/ignacio_lauret_image.png",
      bestRankings: [0, 0, 0, 0],
      points: [0, 0, 0, 0],
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
      addPlayer(player);
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
      removePlayer(pid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addPointsToPlayer(String pid, int points, int category) async {
    final newPoints = getPlayerPoints(pid, category) + points;
    // Try adding points in DB.
    final response = await http.patch(
      Constants.kDbPath + "/players/$pid/points.json",
      body: jsonEncode({"$category":newPoints}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Add points in local memory.
      setPlayerPoints(pid, category, newPoints);
      return true;
    } else {
      return false;
    }
  }

  /* Getters */
  String getPlayerName(String id) {
    return getPlayerById(id).name;
  }

  int getPlayerPoints(String id, int category) {
    return getPlayerById(id).points[category];
  }

  String getPlayerImage(String id) {
    return getPlayerById(id).profileUrl;
  }

  Player getPlayerById(String id) {
    return _players.firstWhere((player) => player.id == id);
  }
}
