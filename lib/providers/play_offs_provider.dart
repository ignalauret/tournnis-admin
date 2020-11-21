import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:tournnis_admin/models/play_off.dart';
import 'package:tournnis_admin/utils/constants.dart';

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

  PlayOff getPlayOff(String tid, int category) {
    return _playOffs.firstWhere((poff) => poff.tid == tid && poff.category == category);
  }
}
