import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/tournament.dart';
import '../utils/constants.dart';

class TournamentsProvider extends ChangeNotifier {
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

  void addLocalTournament(Tournament group) {
    _tournaments.add(group);
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

  /* Getters */

  Tournament getTournamentById(String tid) {
    if (tid == null) return null;
    return _tournaments.firstWhere((tournament) => tournament.id == tid,
        orElse: () => null);
  }

  String getTournamentName(String tid) {
    if(tid == null) return null;
    return getTournamentById(tid).name;
  }
}
