import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/play_off.dart';
import '../models/tournament_match.dart';
import '../providers/matches_provider.dart';
import '../utils/constants.dart';

class PlayOffsProvider extends ChangeNotifier {
  PlayOffsProvider() {
    getPlayOffs();
  }

  List<PlayOff> _playOffs;

  Future<List<PlayOff>> get playOffs async {
    if (_playOffs == null) await getPlayOffs();
    return [..._playOffs];
  }

  Future<void> getPlayOffs() async {
    _playOffs = await fetchPlayOffs();
  }

  PlayOff getPlayOff(String tid, int category) {
    return _playOffs.firstWhere(
      (poff) => poff.tid == tid && poff.category == category,
      orElse: () => PlayOff(
        tid: tid,
        category: category,
        hasStarted: false,
      ),
    );
  }

  void addLocalPlayOff(PlayOff playOff) {
    _playOffs.add(playOff);
    notifyListeners();
  }

  void removeLocalPlayOff(String poid) {
    _playOffs.removeWhere((poff) => poff.id == poid);
    notifyListeners();
  }

  /* CRUD Functions */
  Future<List<PlayOff>> fetchPlayOffs() async {
    final response = await http.get(Constants.kDbPath + "/playOffs.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData == null) return [];
      final List<PlayOff> temp = responseData.entries
          .map(
            (entry) => PlayOff.fromJson(entry.key, entry.value),
          )
          .toList();
      return temp;
    } else {
      return null;
    }
  }

  Future<bool> createPlayOff(BuildContext context, PlayOff playOff) async {
    final List<String> mids = [];
    final matchesData = context.read<MatchesProvider>();
    for (int i = 0; i < playOff.predictedMatches.length; i++) {
      final match = playOff.predictedMatches[i];
      final String mid = await matchesData.createMatch(
        TournamentMatch(
          pid1: match.pid1,
          pid2: match.pid2,
          isPlayOff: true,
          playOffIndex: i,
          tid: match.tid,
          category: match.category,
        ),
      );
      if (mid == null) return false;
      mids.add(mid);
    }
    playOff.matches = mids;
    playOff.hasStarted = true;
    final response = await http.post(Constants.kDbPath + "/playOffs.json",
        body: json.encode(playOff.toJson()));
    if (response.statusCode == 200) {
      addLocalPlayOff(playOff);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deletePlayOff(BuildContext context, PlayOff playOff) async {
    final success = await context
        .read<MatchesProvider>()
        .deleteMatches(context, playOff.matches);
    if (success) {
      final response =
          await http.delete(Constants.kDbPath + "/playOffs/${playOff.id}.json");
      if (response.statusCode == 200) {
        removeLocalPlayOff(playOff.id);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
