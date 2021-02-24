import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tournnis_admin/models/notice.dart';
import 'package:tournnis_admin/utils/constants.dart';

class NoticesProvider extends ChangeNotifier {
  NoticesProvider(this.token) {
    getNotices();
  }

  final String token;
  List<Notice> _notices;

  Future<List<Notice>> get notices async {
    if (_notices == null) await getNotices();
    return [..._notices];
  }

  Future<void> getNotices() async {
    _notices = await fetchNotices();
  }

  void addLocalNotice(Notice notice) {
    _notices.add(notice);
    notifyListeners();
  }

  void removeLocalNotice(String nid) {
    _notices.removeWhere((not) => not.id == nid);
    notifyListeners();
  }

  Future<List<Notice>> fetchNotices() async {
    final response = await http.get(Constants.kDbPath + "/notices.json");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Notice> tempNotices = data["notices"] == null
          ? []
          : Map<String, String>.from(data["notices"])
              .entries
              .map((entry) => Notice(entry.key, entry.value, true))
              .toList();
      final List<Notice> tempSponsors = data["sponsors"] == null
          ? []
          : Map<String, String>.from(data["sponsors"])
              .entries
              .map((entry) => Notice(entry.key, entry.value, false))
              .toList();
      // Create sponsored list of notices
      final List<Notice> temp = [];
      temp.addAll(tempNotices);
      temp.addAll(tempSponsors);
      return temp;
    } else {
      return [];
    }
  }

  Future<bool> createNotice({bool isNotice, String url}) async {
    final trail = isNotice ? "notices" : "sponsors";
    final response = await http.post(Constants.kDbPath + "/notices/$trail.json?auth=$token",
        body: jsonEncode(url));
    if (response.statusCode == 200) {
      addLocalNotice(Notice(jsonDecode(response.body)["name"], url, isNotice));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteNotice(Notice notice) async {
    final trail = notice.isNotice ? "notices" : "sponsors";
    final response = await http
        .delete(Constants.kDbPath + "/notices/$trail/${notice.id}.json?auth=$token");
    if (response.statusCode == 200) {
      removeLocalNotice(notice.id);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadNotice(
      {@required String path, @required bool isNotice}) async {
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
        .addAll({"cloud_name": "tournnis", "upload_preset": "notice_upload"});
    final response = await request.send();
    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      String url = jsonDecode(data)["url"];
      url = "https:" + url.split(":").last;
      return await createNotice(isNotice: isNotice, url: url);
    } else {
      return false;
    }
  }
}
