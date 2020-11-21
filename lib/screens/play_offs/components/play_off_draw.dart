import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/play_off.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/play_offs_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';
import 'package:tournnis_admin/utils/utils.dart';

class PlayOffDraw extends StatefulWidget {
  static const routeName = "/draw";

  @override
  _PlayOffDrawState createState() => _PlayOffDrawState();
}

class _PlayOffDrawState extends State<PlayOffDraw> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments;
    final String tid = arguments["tid"];
    final int category = arguments["category"];

    //final PlayOffsProvider playOffsData = context.read<PlayOffsProvider>();
    final PlayOff playOff =
        PlayOff("aa", tid, category, ["0", "1", "2", "3", "4", "5", "6"]);
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text(
          TournamentMatch.getCategoryName(category),
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      body: FutureBuilder(
        future: context.select<PlayersProvider, Future<List<Player>>>(
            (data) => data.getTournamentRanking(context, tid, category)),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BidirectionalScrollViewPlugin(
              childHeight: 1500,
              childWidth: 1500,
              scrollOverflow: Overflow.clip,
              child: Container(
                height: 1500,
                width: 1500,
                child: Row(
                  children: List.generate(
                      playOff.nRounds,
                      (index) => _buildPredictedRoundColumn(snapshot.data,
                          playOff, playOff.nRounds - index - 1)).toList(),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Column _buildRoundColumn(
      MatchesProvider matchesData, PlayOff playOff, int round) {
    print(round);
    print(playOff.getMatchesOfRound(round));
    return Column(
      children: playOff
          .getMatchesOfRound(round)
          .map(
            (mid) => Container(
              height: 110,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: MatchCard(matchesData.getMatchById(mid)),
            ),
          )
          .toList(),
    );
  }

  Column _buildPredictedRoundColumn(
      List<Player> ranking, PlayOff playOff, int round) {
    print(round);
    print(playOff.getMatchesOfRound(round));
    if (round == playOff.nRounds - 1) {
      final nMatches = Utils.pow2(playOff.nRounds - 1);
      return Column(
        children: List.generate(
          nMatches,
          (index) => Container(
            height: 110,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: MatchCard(
              TournamentMatch(
                pid1: ranking[2 * index].id,
                pid2: ranking[2 * index + 1].id,
                category: playOff.category,
                tid: playOff.tid,
              ),
            ),
          ),
        ).toList(),
      );
    } else {
      return Column(
        children: playOff
            .getMatchesOfRound(round)
            .map(
              (mid) => Container(
                height: 110,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 55.0 + (playOff.nRounds - round - 2) * 110),
                child: MatchCard(
                  TournamentMatch(
                    tid: playOff.tid,
                    category: playOff.category,
                    playOffRound: round,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }
  }
}
