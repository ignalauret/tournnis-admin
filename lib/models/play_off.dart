import 'package:tournnis_admin/utils/utils.dart';

class PlayOff {
  String id;
  final String tid;
  final int category;
  final List<String> matches;

  PlayOff(this.id, this.tid, this.category, this.matches);

  factory PlayOff.fromJson(String id, Map<String, dynamic> json) {
    return PlayOff(
      id,
      json["tid"],
      json["category"],
      List<String>.of(json["matches"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tid": this.tid,
      "category": this.category,
      "matches": this.matches,
    };
  }

  int get nRounds {
    return Utils.log2(matches.length).floor() + 1;
  }

  List<String> getMatchesOfRound(int round) {
    return matches.sublist(Utils.pow2(round) - 1, Utils.pow2(round+1) - 1);
  }
}
