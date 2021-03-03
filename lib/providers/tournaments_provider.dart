import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/tournament.dart';
import '../utils/constants.dart';

class TournamentsProvider extends ChangeNotifier {
  TournamentsProvider(this.token);

  final String token;
  List<Tournament> _tournaments;

  Future<List<Tournament>> get tournaments async {
    if (_tournaments == null) await getTournaments();
    return [..._tournaments];
  }

  Future<List<String>> get tids async {
    if (_tournaments == null) await getTournaments();
    return _tournaments.map((tournament) => tournament.id).toList();
  }

  Future<void> getTournaments() async {
    _tournaments = await fetchTournaments();
  }

  void addLocalTournament(Tournament tournament) {
    _tournaments.add(tournament);
    notifyListeners();
  }

  void editLocalTournament(String tid, String name) {
    final tournament = getTournamentById(tid);
    tournament.name = name;
    notifyListeners();
  }

  void removeLocalTournament(String tid) {
    _tournaments.removeWhere((tournament) => tournament.id == tid);
    notifyListeners();
  }

  /* CRUD Functions */
  Future<List<Tournament>> fetchTournaments() async {
    final response = await http.get(Constants.kDbPath + "/tournaments.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData == null) return [];
      final List<Tournament> temp = responseData.entries
          .map(
            (entry) => Tournament.fromJson(entry.key, entry.value),
          )
          .toList();
      return temp;
    } else {
      return null;
    }
  }

  Future<bool> setCurrentTid(String tid) async {
    final response = await http.patch(
      Constants.kDbPath + "/config.json?auth=$token",
      body: jsonEncode({
        "currentTid": tid,
        "inGroups": 0,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /* Not so important to wait response */
  Future<void> setInGroups() async {
    await http.patch(
      Constants.kDbPath + "/config.json?aut=$token",
      body: jsonEncode({
        "inGroups": 1,
      }),
    );
  }

  Future<bool> createTournament(String name) async {
    final tournament = Tournament(name: name, startDate: DateTime.now());
    final response = await http.post(
      Constants.kDbPath + "/tournaments.json?auth=$token",
      body: jsonEncode(tournament.toJson()),
    );
    if (response.statusCode == 200) {
      tournament.id = jsonDecode(response.body)["name"];
      addLocalTournament(tournament);
      return await setCurrentTid(tournament.id);
    } else {
      return false;
    }
  }

  Future<bool> editTournament(String tid, String name) async {
    final response = await http.patch(
      Constants.kDbPath + "/tournaments/$tid.json?auth=$token",
      body: jsonEncode({"name": name}),
    );
    if (response.statusCode == 200) {
      editLocalTournament(tid, name);
      return true;
    } else {
      return false;
    }
  }

  /* Getters */

  Tournament getTournamentById(String tid) {
    if (tid == null) return null;
    return _tournaments.firstWhere((tournament) => tournament.id == tid,
        orElse: () => null);
  }

  String getTournamentName(String tid) {
    if (tid == null) return null;
    return getTournamentById(tid).name;
  }
}
