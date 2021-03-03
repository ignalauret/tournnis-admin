import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/player.dart';
import '../models/tournament_match.dart';
import '../utils/constants.dart';

class PlayersProvider extends ChangeNotifier {
  PlayersProvider(this.token) {
    getPlayers();
  }

  final String token;
  List<Player> _players = [];

  Future<List<Player>> get players async {
    if (_players == null) await getPlayers();
    return [..._players];
  }

  Future<void> getPlayers() async {
    _players = await fetchPlayers();
    notifyListeners();
  }

  void addLocalPlayer(Player player) {
    _players.add(player);
    notifyListeners();
  }

  void removeLocalPlayer(String pid) {
    _players.removeWhere((player) => player.id == pid);
    notifyListeners();
  }

  void editLocalPlayer(String pid, Map<String, dynamic> editData) {
    final player = getPlayerById(pid);
    player.name = editData["name"];
    player.club = editData["club"];
    player.handed = editData["handed"] == "r" ? Handed.Right : Handed.Left;
    player.backhand =
        editData["backhand"] == 1 ? Backhand.OneHanded : Backhand.TwoHanded;
    player.birth = DateTime.parse(editData["birth"]);
    player.racket = editData["racket"];
    player.imageUrl = editData["coverUrl"];
    notifyListeners();
  }

  void setLocalPlayerPoints(String id, int category, int points) {
    getPlayerById(id).globalCategoryPoints[category] = points;
    notifyListeners();
  }

  void setLocalPlayerTournamentPoints(
      String pid, String tid, int category, int points) {
    getPlayerById(pid).tournamentCategoryPoints[category][tid] = points;
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

  Future<bool> createPlayer({
    String name,
    String club,
    Backhand backhand,
    Handed hand,
    DateTime birthDate,
    String racket,
    String imageUrl,
  }) async {
    final player = Player(
      name: name,
      club: club,
      nationality: "Argentina",
      birth: birthDate,
      backhand: backhand,
      racket: racket,
      handed: hand,
      imageUrl: imageUrl,
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
      Constants.kDbPath + "/players.json?auth=$token",
      body: jsonEncode(player.toJson()),
    );

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
        await http.delete(Constants.kDbPath + "/players/$pid.json?auth=$token");
    if (response.statusCode == 200) {
      // Remove from local memory.
      removeLocalPlayer(pid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editPlayer({
    String pid,
    String name,
    String club,
    Handed hand,
    Backhand backhand,
    DateTime birthDate,
    String racket,
    String imageUrl,
  }) async {
    final editData = {
      "name": name,
      "club": club,
      "handed": hand == Handed.Right ? "r" : "l",
      "backhand": backhand == Backhand.OneHanded ? 1 : 2,
      "birth": birthDate.toString(),
      "racket": racket,
      "coverUrl": imageUrl,
    };
    final response = await http.patch(
      Constants.kDbPath + "/players/$pid.json?auth=$token",
      body: jsonEncode(editData),
    );
    if (response.statusCode == 200) {
      editLocalPlayer(pid, editData);
      return true;
    } else {
      return false;
    }
  }

  Future<String> uploadImage(String path) async {
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(Constants.kCloudinaryUploadPath),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        path,
      ),
    );
    request.fields
        .addAll({"cloud_name": "tournnis", "upload_preset": "profile_upload"});
    final response = await request.send();
    final data = await response.stream.bytesToString();
    String url = jsonDecode(data)["url"];
    url = "https:" + url.split(":").last;
    return url;
  }

  Future<bool> addMatchPoints(
      TournamentMatch match, int points1, int points2) async {
    await addPointsToPlayer(match.pid1, points1, match.category, match.tid);
    return await addPointsToPlayer(
        match.pid2, points2, match.category, match.tid);
  }

  Future<bool> addPointsToPlayer(
      String pid, int points, int category, String tid) async {
    final newPoints = getPlayerPoints(pid, category) + points;
    final newTournamentPoints =
        getPlayerTournamentPoints(pid, tid, category) + points;
    // Try adding points in DB.
    final response = await http.patch(
      Constants.kDbPath + "/players/$pid/points.json?auth=$token",
      body: jsonEncode({"$category": newPoints}),
    );

    if (response.statusCode == 200) {
      // Add points in local memory.
      setLocalPlayerPoints(pid, category, newPoints);
      // try adding points to tournament in DB.
      final response2 = await http.patch(
        Constants.kDbPath + "/players/$pid/tournamentPoints/$category.json?auth=$token",
        body: jsonEncode({"$tid": newTournamentPoints}),
      );
      if (response2.statusCode == 200) {
        setLocalPlayerTournamentPoints(pid, tid, category, newTournamentPoints);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  /* Getters */
  String getPlayerName(String id) {
    if (id == null) return " ";
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

  // final Map<String, List<Player>> tournamentRankingCache = {};
  final Map<int, List<Player>> globalRankingCache = {};

  void refreshGlobalCache() {
    globalRankingCache.clear();
  }

  Future<List<Player>> getGlobalRanking(int category) async {
    // Return if cached
    if (globalRankingCache.containsKey(category)) {
      return globalRankingCache[category];
    }
    final playersList = await players;
    // Remove players with no points.
    playersList
        .removeWhere((player) => player.getPointsOfCategory(category) == 0);
    // Sort by category global points.
    playersList.sort(
      (p1, p2) => p2.getPointsOfCategory(category).compareTo(
            p1.getPointsOfCategory(category),
          ),
    );
    globalRankingCache[category] = [...playersList];
    notifyListeners();
    return playersList;
  }

  Future<int> getPlayerGlobalRanking(String pid, int category) async {
    if (pid == null) return 0;
    // If not cached, get ranking
    if (!globalRankingCache.containsKey(category)) {
      await getGlobalRanking(category);
    }
    return globalRankingCache[category]
            .indexWhere((player) => player.id == pid) +
        1;
  }

  /* Dev */

  // Future<void> restartPoints() async {
  //   for (Player player in _players) {
  //     await http.patch(
  //       Constants.kDbPath + "/players/${player.id}/points.json",
  //       body: jsonEncode({"0": 0, "1": 0, "2": 0, "3": 0}),
  //     );
  //     await http.patch(
  //       Constants.kDbPath + "/players/${player.id}/tournamentPoints.json",
  //       body: jsonEncode({
  //         "0": {"default": 0},
  //         "1": {"default": 0},
  //         "2": {"default": 0},
  //         "3": {"default": 0}
  //       }),
  //     );
  //   }
  // }
}
