import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:http/http.dart' as http;
import '../models/group_zone.dart';

class GroupsProvider extends ChangeNotifier {
  GroupsProvider() {
    getGroups();
  }

  List<GroupZone> _groups;

  Future<List<GroupZone>> get groups async {
    if (_groups == null) await getGroups();
    return [..._groups];
  }

  Future<void> getGroups() async {
    _groups = await fetchGroups();
  }

  GroupZone getGroupById(String id) {
    if (id == null) return null;
    return _groups.firstWhere((group) => group.id == id, orElse: () => null);
  }

  void addLocalGroup(GroupZone group) {
    _groups.add(group);
    notifyListeners();
  }

  void removeLocalGroup(String gid) {
    _groups.removeWhere((group) => group.id == gid);
    notifyListeners();
  }

  void changeLocalGroupName(String gid, String newName) {
    final group = getGroupById(gid);
    group.name = newName;
    notifyListeners();
  }

  /* CRUD Functions */
  Future<List<GroupZone>> fetchGroups() async {
    final response = await http.get(Constants.kDbPath + "/groups.json");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData == null) return [];
      final List<GroupZone> temp = responseData.entries
          .map(
            (entry) => GroupZone.fromJson(entry.key, entry.value),
          )
          .toList();
      temp.sort((g1, g2) => g1.index.compareTo(g2.index));
      return temp;
    } else {
      return null;
    }
  }

  List<String> getGroupsWinners(BuildContext context, String tid, int category) {
    final List<String> pids = [];
    final matchesData = context.watch<MatchesProvider>();
    for(int i = 0; i < _groups.length; i++) {
      if(_groups[i].tid != tid || _groups[i].category != category) continue;
      final players = [..._groups[i].playersIds];
      players.sort((p1, p2) => matchesData.comparePlayersWithPid(context, tid, category, p1, p2));
      pids.addAll(players.sublist(0,2));
    }
    return pids;
  }

  Future<bool> createGroup(BuildContext context, GroupZone group) async {
    final ids =
        await context.read<MatchesProvider>().createMatchesOfGroup(group);
    if (ids == null) return false;
    group.matchesIds = ids;
    final response = await http.post(
      Constants.kDbPath + "/groups.json",
      body: jsonEncode(group.toJson()),
    );
    if (response.statusCode == 200) {
      group.id = jsonDecode(response.body)["name"];
      addLocalGroup(group);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteGroup(BuildContext context, String gid) async {
    final group = getGroupById(gid);
    final response = await http.delete(Constants.kDbPath + "/groups/$gid.json");
    if (response.statusCode == 200) {
      final bool success = await context
          .read<MatchesProvider>()
          .deleteMatches(context, group.matchesIds);
      if (success) {
        removeLocalGroup(gid);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }

  Future<bool> changeGroupName(String gid, String newName) async {
    final response = await http.patch(
      Constants.kDbPath + "/groups/$gid.json",
      body: jsonEncode({"name": newName}),
    );
    if (response.statusCode == 200) {
      changeLocalGroupName(gid, newName);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addPlayerToGroup(
      BuildContext context, String gid, String pid) async {
    final group = getGroupById(gid);
    // Create matches
    final matchData = context.read<MatchesProvider>();
    for (String otherPid in group.playersIds) {
      final mid = await matchData.createMatch(TournamentMatch(
        pid1: pid,
        pid2: otherPid,
        result1: null,
        result2: null,
        date: null,
        tid: group.tid,
        isPlayOff: false,
        category: group.category,
        playOffRound: null,
      ));
      if (mid != null) {
        group.matchesIds.add(mid);
      } else {
        return false;
      }
    }
    group.playersIds.add(pid);
    final response = await http.patch(
      Constants.kDbPath + "/groups/$gid.json",
      body: jsonEncode(
        {"players": group.playersIds, "matches": group.matchesIds},
      ),
    );
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removePlayerOfGroup(
      BuildContext context, String gid, String pid) async {
    final group = getGroupById(gid);
    // Create matches
    final matchData = context.read<MatchesProvider>();
    final List<String> toRemove = [];
    for (String mid in group.matchesIds) {
      final match = matchData.getMatchById(mid);
      if (match.pid1 == pid || match.pid2 == pid) {
        await matchData.deleteMatch(context, mid);
        toRemove.add(mid);
      }
    }
    group.matchesIds.removeWhere((mid) => toRemove.contains(mid));
    group.playersIds.remove(pid);
    final response = await http.patch(
      Constants.kDbPath + "/groups/$gid.json",
      body: jsonEncode(
        {"players": group.playersIds, "matches": group.matchesIds},
      ),
    );
    if (response.statusCode == 200) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
