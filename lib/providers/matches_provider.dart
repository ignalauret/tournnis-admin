import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/constants.dart';

class MatchesProvider extends ChangeNotifier {
  MatchesProvider() {
    getMatches();
  }

  List<TournamentMatch> _matches;

  Future<List<TournamentMatch>> get matches async {
    if (_matches == null) await getMatches();
    return [..._matches];
  }

  Future<void> getMatches() async {
    _matches = await fetchMatches();
  }

  TournamentMatch getMatchById(String id) {
    if (id == null) return null;
    return _matches.firstWhere((match) => match.id == id, orElse: () => null);
  }

  void addLocalMatch(TournamentMatch match) {
    _matches.add(match);
    notifyListeners();
  }

  void removeLocalMatch(String mid) {
    _matches.removeWhere((match) => match.id == mid);
    notifyListeners();
  }

  void addLocalResult(String id, List<int> result1, List<int> result2) {
    final match = getMatchById(id);
    match.result1 = result1;
    match.result2 = result2;
    notifyListeners();
  }

  /* CRUD Functions */
  Future<List<TournamentMatch>> fetchMatches() async {
    final response = await http.get(Constants.kDbPath + "/matches.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData == null) return [];
      final List<TournamentMatch> temp = responseData.entries
          .map(
            (entry) => TournamentMatch.fromJson(entry.key, entry.value),
          )
          .toList();
      return temp;
    } else {
      return null;
    }
  }

  Future<bool> createMatch(TournamentMatch match) async {
    // Try adding match in DB.
    final response = await http.post(
      Constants.kDbPath + "/matches.json",
      body: jsonEncode(match.toJson()),
    );
    if (response.statusCode == 200) {
      // Add match in local memory.
      match.id = jsonDecode(response.body)["name"];
      addLocalMatch(match);
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteMatch(String mid) async {
    // Try deleting match in DB.
    final response =
        await http.delete(Constants.kDbPath + "/matches/$mid.json");
    if (response.statusCode == 200) {
      // Delete match in local memory.
      removeLocalMatch(mid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addResult(
      TournamentMatch match, String result, PlayersProvider playersData) async {
    final List<int> result1 = [];
    final List<int> result2 = [];
    final sets = result.split(" ");
    for (String set in sets) {
      final games = set.split(".");
      result1.add(int.parse(games[0]));
      result2.add(int.parse(games[1]));
    }

    // Try updating result in DB
    final response = await http.patch(
      Constants.kDbPath + "/matches/${match.id}.json",
      body: jsonEncode({
        "result1": result1,
        "result2": result2,
      }),
    );
    if (response.statusCode == 200) {
      addLocalResult(match.id, result1, result2);
      await playersData.addMatchPoints(match);
      return true;
    } else {
      return false;
    }
  }

  /* Predicates */
  bool playerHasMatches(String pid) {
    for (TournamentMatch match in _matches) {
      if (match.pid1 == pid || match.pid2 == pid) return true;
    }
    return false;
  }
}
