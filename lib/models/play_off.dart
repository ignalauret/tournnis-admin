import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/utils/utils.dart';

class PlayOff {
  String id;
  final String tid;
  final int category;
  List<String> matches;
  List<TournamentMatch> predictedMatches;
  bool hasStarted;

  PlayOff({this.id, this.tid, this.category, this.matches, this.hasStarted, this.predictedMatches});

  factory PlayOff.fromJson(String id, Map<String, dynamic> json) {
    return PlayOff(
      id: id,
      tid: json["tid"],
      category: json["category"],
      matches: List<String>.of(json["matches"]),
      hasStarted: json["hasStarted"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tid": this.tid,
      "category": this.category,
      "matches": this.matches,
      "hasStarted": this.hasStarted,
    };
  }

  int get nRounds {
    return Utils.log2(matches.length).floor() + 1;
  }

  List<String> getMatchesOfRound(int round) {
    return matches.sublist(Utils.pow2(round) - 1, Utils.pow2(round + 1) - 1);
  }

  List<TournamentMatch> getPredictedMatchesOfRound(int round) {
    return predictedMatches.sublist(Utils.pow2(round) - 1, Utils.pow2(round + 1) - 1);
  }
}
