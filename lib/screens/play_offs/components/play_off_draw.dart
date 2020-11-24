import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/play_off.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';
import 'package:tournnis_admin/utils/utils.dart';

import 'draw.dart';

const kMatchOrder = [0, 15, 8, 7, 4, 11, 12, 3, 2, 13, 10, 5, 6, 9, 14, 1];
const kGroupMatchOrder = [0, 3, 4, 7, 8, 11, 12, 15, 2, 1, 6, 5, 10, 9, 14, 13];

class PlayOffDraw extends StatefulWidget {
  static const routeName = "/draw";

  @override
  _PlayOffDrawState createState() => _PlayOffDrawState();
}

class _PlayOffDrawState extends State<PlayOffDraw> {
  @override
  Widget build(BuildContext context) {
    final PlayOff playOff = ModalRoute.of(context).settings.arguments;
    final GroupsProvider groupsData = context.watch<GroupsProvider>();

    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text(
          playOff.hasStarted
              ? TournamentMatch.getCategoryName(playOff.category)
              : "Predicción " +
                  TournamentMatch.getCategoryName(playOff.category),
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      body: FutureBuilder<List<Player>>(
        future: context.select<PlayersProvider, Future<List<Player>>>(
          (data) =>
              data.getTournamentRanking(context, playOff.tid, playOff.category),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (playOff.category == 0) {
              final players = groupsData.getGroupsWinners(
                  context, playOff.tid, playOff.category);
              final List<TournamentMatch> matches = [];
              for (int i = 0; i < 7; i++) {
                matches.add(
                  TournamentMatch(
                    tid: playOff.tid,
                    category: playOff.category,
                    playOffRound: i,
                  ),
                );
              }
              matches.addAll(
                List.generate(
                  Utils.pow2(playOff.nRounds - 1),
                  (index) => TournamentMatch(
                    pid1: players[kGroupMatchOrder[2 * index]],
                    pid2: players[kGroupMatchOrder[2 * index + 1]],
                    category: playOff.category,
                    tid: playOff.tid,
                  ),
                ),
              );
              playOff.predictedMatches = matches;
            } else {
              final List<TournamentMatch> matches = [];
              for (int i = 0; i < 7; i++) {
                matches.add(
                  TournamentMatch(
                    tid: playOff.tid,
                    category: playOff.category,
                    playOffRound: i,
                  ),
                );
              }
              matches.addAll(
                List.generate(
                  Utils.pow2(playOff.nRounds - 1),
                  (index) => TournamentMatch(
                    pid1: snapshot.data[kMatchOrder[2 * index]].id,
                    pid2: snapshot.data[kMatchOrder[2 * index + 1]].id,
                    category: playOff.category,
                    tid: playOff.tid,
                  ),
                ),
              );
              playOff.predictedMatches = matches;
            }
            return Draw(playOff);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

      // body: playOff.hasStarted
      //     ? DiagonalScrollView(
      //         maxHeight: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
      //         maxWidth: (size.width * 0.85 + 20) * playOff.nRounds,
      //         child: Container(
      //           height: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
      //           width: (size.width * 0.85 + 20) * playOff.nRounds,
      //           child: Row(
      //             children: List.generate(
      //                 playOff.nRounds,
      //                 (index) => _buildRoundColumn(matchesData, playOff,
      //                     playOff.nRounds - index - 1)).toList(),
      //           ),
      //         ),
      //       )
      //     : FutureBuilder(
      //         future: context.select<PlayersProvider, Future<List<Player>>>(
      //             (data) => data.getTournamentRanking(
      //                 context, playOff.tid, playOff.category)),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             return DiagonalScrollView(
      //               maxHeight: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
      //               maxWidth: (size.width * 0.85 + 20) * playOff.nRounds,
      //               child: Container(
      //                 height: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
      //                 width: (size.width * 0.85 + 20) * playOff.nRounds,
      //                 child: Row(
      //                   children: List.generate(
      //                       playOff.nRounds,
      //                       (index) => _buildPredictedRoundColumn(snapshot.data,
      //                           playOff, playOff.nRounds - index - 1)).toList(),
      //                 ),
      //               ),
      //             );
      //           } else {
      //             return Center(
      //               child: CircularProgressIndicator(),
      //             );
      //           }
      //         },
      //       ),
    );
  }

  Column _buildRoundColumn(
      MatchesProvider matchesData, PlayOff playOff, int round) {
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
    if (round == playOff.nRounds - 1) {
      final nMatches = Utils.pow2(playOff.nRounds - 1);
      return Column(
        children: [
          Container(
            height: 30,
            child: Text(
              kRoundNames[round],
              style: CustomStyles.kTitleStyle,
            ),
          ),
          ...List.generate(
            nMatches,
            (index) => Container(
              height: 110,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: MatchCard(
                TournamentMatch(
                  pid1: ranking[kMatchOrder[2 * index]].id,
                  pid2: ranking[kMatchOrder[2 * index + 1]].id,
                  category: playOff.category,
                  tid: playOff.tid,
                ),
              ),
            ),
          ).toList(),
        ],
      );
    } else {
      return Column(
        children: [
          Container(
            height: 30,
            child: Text(
              kRoundNames[round],
              style: CustomStyles.kTitleStyle,
            ),
          ),
          ...playOff
              .getMatchesOfRound(round)
              .map(
                (mid) => Container(
                  height: 110,
                  margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 55.0 +
                          (playOff.nRounds - round - 2) * 110 +
                          max(0, (playOff.nRounds - round - 3)) * 110),
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
        ],
      );
    }
  }
}
