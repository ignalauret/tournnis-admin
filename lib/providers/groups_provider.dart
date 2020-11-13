import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void editLocalGroup(String gid, Map<String, dynamic> editData) {
    final group = getGroupById(gid);
    group.name = editData["name"];
    group.playersIds = editData["players"];
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
      return temp;
    } else {
      return null;
    }
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

  Future<bool> editGroupName(BuildContext context, String gid, String name,
      List<String> pids, List<String> previousPids) async {
    final editData = {
      "name": name,
      "players": pids,
    };
    final response = await http.patch(
      Constants.kDbPath + "/groups/$gid.json",
      body: jsonEncode(editData),
    );
    if (response.statusCode == 200) {
      // TODO: Call MatchesProvider.editPlayerOfMatches with the diff
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteGroup(BuildContext context, String gid) async {
    final group = getGroupById(gid);
    final response = await http.delete(Constants.kDbPath + "/groups/$gid.json");
    if (response.statusCode == 200) {
      final bool success =
          await context.read<MatchesProvider>().deleteMatches(group.matchesIds);
      if (success) {
        removeLocalGroup(gid);
        return true;
      }
      return false;
    } else {
      return false;
    }
  }
}
