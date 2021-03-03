import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/group_zone.dart';
import '../models/player.dart';
import '../models/tournament_match.dart';
import '../providers/play_offs_provider.dart';
import '../providers/players_provider.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';

class MatchesProvider extends ChangeNotifier {
  MatchesProvider(this.token) {
    getMatches();
  }

  final String token;
  List<TournamentMatch> _matches;

  Future<List<TournamentMatch>> get matches async {
    if (_matches == null) await getMatches();
    return [..._matches];
  }

  List<TournamentMatch> get matchesSync {
    return [..._matches];
  }

  Future<void> getMatches() async {
    _matches = await fetchMatches();
  }

  TournamentMatch getMatchById(String id) {
    if (id == null) return null;
    return _matches.firstWhere((match) => match.id == id, orElse: () => null);
  }

  List<TournamentMatch> getMatchesById(List<String> ids) {
    return ids.map((id) => getMatchById(id)).toList();
  }

  List<TournamentMatch> getAllPlayerMatches(String pid) {
    final matches = _matches
        .where((match) => match.pid1 == pid || match.pid2 == pid)
        .toList();
    return matches;
  }

  List<TournamentMatch> getPlayerMatches(String pid, String tid, int category) {
    return _matches
        .where((match) =>
            (match.pid1 == pid || match.pid2 == pid) &&
            match.tid == tid &&
            match.category == category)
        .toList();
  }

  List<TournamentMatch> getPlayerMatchesFromTournament(
      String pid, String tid, int category) {
    final matches = _matches
        .where((match) =>
            match.pid1 == pid ||
            match.pid2 == pid && match.category == category && match.tid == tid)
        .toList();
    return matches;
  }

  void addLocalMatch(TournamentMatch match) {
    _matches.add(match);
    notifyListeners();
  }

  void removeLocalMatch(String mid) {
    _matches.removeWhere((match) => match.id == mid);
    notifyListeners();
  }

  void editLocalMatch(String mid, Map<String, dynamic> editData) {
    final match = getMatchById(mid);
    match.pid1 = editData["pid1"];
    match.pid2 = editData["pid2"];
    match.date = DateTime.parse(editData["date"]);
    match.category = editData["category"];
    notifyListeners();
  }

  void editLocalPlayerOfMatch(String mid, String prevPid, String newPid) {
    final match = getMatchById(mid);
    if (match.pid1 == prevPid) {
      match.pid1 = newPid;
    } else {
      match.pid2 = newPid;
    }
    notifyListeners();
  }

  void editLocalPlayerOfMatchAtPosition(
      String mid, int position, String newPid) {
    final match = getMatchById(mid);
    if (position == 0) {
      match.pid1 = newPid;
    } else {
      match.pid2 = newPid;
    }
    notifyListeners();
  }

  void addLocalDate(String id, DateTime date) {
    final match = getMatchById(id);
    match.date = date;
    notifyListeners();
  }

  void addLocalResult(
      String id, List<int> result1, List<int> result2, int isWo) {
    final match = getMatchById(id);
    match.result1 = result1;
    match.result2 = result2;
    match.isWo = isWo;
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

  Future<String> createMatch(TournamentMatch match) async {
    // Try adding match in DB.
    final response = await http.post(
      Constants.kDbPath + "/matches.json?",
      body: jsonEncode(match.toJson()),
    );
    if (response.statusCode == 200) {
      // Add match in local memory.
      match.id = jsonDecode(response.body)["name"];
      addLocalMatch(match);
      return match.id;
    } else {
      return null;
    }
  }

  Future<List<String>> createMatchesOfGroup(GroupZone group) async {
    // Create rivals list for the matches
    final List<List<String>> rivals = [];
    for (int i = 0; i < group.playersIds.length; i++) {
      for (int j = i + 1; j < group.playersIds.length; j++) {
        rivals.add([group.playersIds[i], group.playersIds[j]]);
      }
    }
    final List<String> ids = [];
    for (List<String> players in rivals) {
      final match = TournamentMatch(
        pid1: players[0],
        pid2: players[1],
        result1: null,
        result2: null,
        date: null,
        tid: group.tid,
        isPlayOff: false,
        category: group.category,
      );
      final id = await createMatch(match);
      if (id == null) return null;
      ids.add(id);
    }
    return ids;
  }

  Future<bool> deleteMatch(BuildContext context, String mid) async {
    // Try deleting match in DB.
    final response =
        await http.delete(Constants.kDbPath + "/matches/$mid.json?auth=$token");
    if (response.statusCode == 200) {
      final match = getMatchById(mid);
      // If match has ended, remove points.
      if (match.hasEnded && !match.isPlayOff) {
        await context.read<PlayersProvider>().addPointsToPlayer(match.pid1,
            -1 * match.firstPlayerPoints, match.category, match.tid);
        await context.read<PlayersProvider>().addPointsToPlayer(match.pid2,
            -1 * match.secondPlayerPoints, match.category, match.tid);
      }
      //Delete match in local memory.
      removeLocalMatch(mid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteMatches(BuildContext context, List<String> mids) async {
    for (String mid in mids) {
      if (!await deleteMatch(context, mid)) return false;
    }
    return true;
  }

  Future<bool> editPlayerOfMatches(
      List<String> mids, String prevPid, String newPid) async {
    for (String mid in mids) {
      if (!await editPlayerOfMatch(mid, prevPid, newPid)) return false;
    }
    return true;
  }

  Future<bool> editPlayerOfMatch(
      String mid, String prevPid, String newPid) async {
    final match = getMatchById(mid);
    if (match.pid1 == prevPid) {
      return await editPlayerOfMatchAtPosition(mid, 0, newPid);
    } else if (match.pid2 == prevPid) {
      return await editPlayerOfMatchAtPosition(mid, 1, newPid);
    } else {
      return true;
    }
  }

  Future<bool> editPlayerOfMatchAtPosition(
      String mid, int position, String newPid) async {
    Map<String, String> body;
    if (position == 0) {
      body = {"pid1": newPid};
    } else {
      body = {"pid2": newPid};
    }
    final response = await http.patch(
      Constants.kDbPath + "/matches/$mid.json?auth=$token",
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      editLocalPlayerOfMatchAtPosition(mid, position, newPid);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addDate(TournamentMatch match, DateTime date) async {
    final response = await http.patch(
      Constants.kDbPath + "/matches/${match.id}.json?auth=$token",
      body: jsonEncode({
        "date": date.toString(),
      }),
    );
    if (response.statusCode == 200) {
      addLocalDate(match.id, date);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeDate(String mid) async {
    final response = await http.patch(
      Constants.kDbPath + "/matches/$mid.json?auth=$token",
      body: jsonEncode({
        "date": null,
      }),
    );
    if (response.statusCode == 200) {
      addLocalDate(mid, null);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addResult(
    BuildContext context,
    TournamentMatch match,
    String result,
  ) async {
    // Parse result
    final List<int> result1 = [];
    final List<int> result2 = [];
    int isWo = 0;
    if (result == "1") {
      result1.addAll([0, 0]);
      result2.addAll([6, 6]);
      isWo = 1;
    } else if (result == "2") {
      result1.addAll([6, 6]);
      result2.addAll([0, 0]);
      isWo = 2;
    } else {
      final sets = result.split(" ");
      for (String set in sets) {
        final games = set.split(".");
        result1.add(int.parse(games[0]));
        result2.add(int.parse(games[1]));
      }
    }
    // Try updating result in DB
    final response = await http.patch(
      Constants.kDbPath + "/matches/${match.id}.json?auth=$token",
      body: jsonEncode({
        "result1": result1,
        "result2": result2,
        "isWo": isWo,
      }),
    );
    if (response.statusCode == 200) {
      if (match.isPlayOff) {
        // If play off, add winner to next match.
        final playOffMatches = context
            .read<PlayOffsProvider>()
            .getPlayOff(match.tid, match.category)
            .matches;
        addLocalResult(match.id, result1, result2, isWo);
        // Check if is the final match
        if (match.playOffIndex == 0) {
          await endTournament(context, match);
          return true;
        } else {
          final success = await editPlayerOfMatchAtPosition(
            playOffMatches[Utils.getNextMatchIndex(match.playOffIndex)],
            Utils.getNextMatchPosition(match.playOffIndex),
            match.winnerId,
          );
          return success;
        }
      } else {
        // If not play off, add points to player.
        int points1 = 0;
        int points2 = 0;
        // Get previous points
        if (match.hasEnded) {
          points1 = -1 * match.firstPlayerPoints;
          points2 = -1 * match.secondPlayerPoints;
        }
        addLocalResult(match.id, result1, result2, isWo);
        points1 += match.firstPlayerPoints;
        points2 += match.secondPlayerPoints;
        return await context
            .read<PlayersProvider>()
            .addMatchPoints(match, points1, points2);
      }
    } else {
      return false;
    }
  }

  Future<void> endTournament(
      BuildContext context, TournamentMatch finalMatch) async {
    final playOffMatches = _matches
        .where((match) => match.tid == finalMatch.tid && match.isPlayOff)
        .toList();
    final playersProvider = context.read<PlayersProvider>();
    // Add points to everyone except for the champion.
    for (TournamentMatch match in playOffMatches) {
      final loserId = match.loserId;
      await playersProvider.addPointsToPlayer(
          loserId,
          Utils.getPlayOffPointsFromIndex(match.playOffIndex),
          match.category,
          match.tid);
    }
    // Add points to champion.
    final championId = finalMatch.winnerId;
    await playersProvider.addPointsToPlayer(
        championId,
        Utils.getPlayOffPointsFromIndex(-1),
        finalMatch.category,
        finalMatch.tid);
  }

  /* Getters */

  int comparePlayers(String tid, int category, Player p1, Player p2) {
    if (p1.getTournamentPointsOfCategory(tid, category) !=
        p2.getTournamentPointsOfCategory(tid, category)) {
      return p2
          .getTournamentPointsOfCategory(tid, category)
          .compareTo(p1.getTournamentPointsOfCategory(tid, category));
    }
    final Map<String, int> results1 =
        getPlayerResultsFromTournament(p1.id, tid, category);
    final Map<String, int> results2 =
        getPlayerResultsFromTournament(p2.id, tid, category);
    // Compare wins
    if (results1["wins"] != results2["wins"]) {
      return results2["wins"].compareTo(results1["wins"]);
    }
    // Compare sets diff
    if (results1["setDiff"] != results2["setDiff"]) {
      return results2["setDiff"].compareTo(results1["setDiff"]);
    }
    return results2["gameDiff"].compareTo(results1["gameDiff"]);
  }

  int comparePlayersWithPid(BuildContext context, String tid, int category,
      String pid1, String pid2) {
    final p1 = context
        .select<PlayersProvider, Player>((data) => data.getPlayerById(pid1));
    final p2 = context
        .select<PlayersProvider, Player>((data) => data.getPlayerById(pid2));
    return comparePlayers(tid, category, p1, p2);
  }

  Map<String, int> getPlayerResultsFromTournament(
      String pid, String tid, int category) {
    int wins = 0;
    int superTiebreaks = 0;
    int loses = 0;
    int setDiff = 0;
    int gameDiff = 0;
    for (TournamentMatch match in _matches) {
      if (!match.hasEnded || match.tid != tid || match.category != category)
        continue;
      if (match.pid1 == pid || match.pid2 == pid) {
        if (match.winnerId == pid) {
          wins++;
        } else if (match.result1.length == 3) {
          superTiebreaks++;
        } else {
          loses++;
        }
        gameDiff += match.gamesDifferenceOfPlayer(pid);
        setDiff += match.setsDifferenceOfPlayer(pid);
      }
    }
    return {
      "wins": wins,
      "superTiebreaks": superTiebreaks,
      "loses": loses,
      "setDiff": setDiff,
      "gameDiff": gameDiff,
    };
  }

  List<TournamentMatch> getMatchesOfPlayerOnCategory(String pid, int category) {
    final matches = _matches
        .where((match) =>
            (match.pid1 == pid || match.pid2 == pid) &&
            match.category == category &&
            match.date != null)
        .toList();
    matches.sort((m1, m2) => m2.date.compareTo(m1.date));
    return matches;
  }

  int getPlayerTournamentsOnCategory(String pid, int category) {
    final List<String> tournaments = [];
    final matches = getMatchesOfPlayerOnCategory(pid, category);
    for (TournamentMatch match in matches) {
      if (!tournaments.contains(match.tid)) {
        tournaments.add(match.tid);
      }
    }
    return tournaments.length;
  }

  int getPlayerTitlesOnCategory(String pid, int category) {
    int count = 0;
    final matches = getMatchesOfPlayerOnCategory(pid, category);
    for (TournamentMatch match in matches) {
      if (match.playOffIndex == 0 && match.winnerId == pid) {
        count += 1;
      }
    }
    return count;
  }

  Map<String, int> getPlayerTournamentHistory(String pid, int category) {
    return {
      "played": getPlayerTournamentsOnCategory(pid, category),
      "titles": getPlayerTitlesOnCategory(pid, category),
    };
  }

  Map<String, int> getPlayerAnnualResultsOnCategory(String pid, int category) {
    int wins = 0;
    int superTiebreaks = 0;
    int loses = 0;
    int setsWon = 0;
    int setsLost = 0;
    int setDiff = 0;
    int gameDiff = 0;
    int gamesWon = 0;
    int gamesLost = 0;
    int tiebreaksWon = 0;
    int tiebreaksLost = 0;
    for (TournamentMatch match in _matches) {
      if (!match.hasEnded || match.category != category) continue;
      if (match.pid1 == pid || match.pid2 == pid) {
        if (match.winnerId == pid) {
          wins++;
        } else if (match.result1.length == 3) {
          superTiebreaks++;
        } else {
          loses++;
        }
        setDiff += match.setsDifferenceOfPlayer(pid);
        setsWon += match.setsWonByPlayer(pid);
        setsLost += match.setsLostByPlayer(pid);
        gameDiff += match.gamesDifferenceOfPlayer(pid);
        gamesWon += match.gamesWonByPlayer(pid);
        gamesLost += match.gamesLostByPlayer(pid);
        tiebreaksWon += match.tiebreaksWonByPlayer(pid);
        tiebreaksLost += match.tiebreaksLostByPlayer(pid);
      }
    }
    return {
      "wins": wins,
      "superTiebreaks": superTiebreaks,
      "loses": loses,
      "setDiff": setDiff,
      "gameDiff": gameDiff,
      "winSets": setsWon,
      "loseSets": setsLost,
      "winGames": gamesWon,
      "loseGames": gamesLost,
      "winTiebreaks": tiebreaksWon,
      "loseTiebreaks": tiebreaksLost,
      "totalMatches": wins + loses + superTiebreaks,
    };
  }
}
