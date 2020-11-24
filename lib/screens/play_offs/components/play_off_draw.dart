import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/play_off.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/edit_play_off/edit_play_off_screen.dart';
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
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditPlayOffScreen.routeName, arguments: playOff);
              }),
        ],
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
              for (int i = 0; i < 1; i++) {
                matches.add(
                  TournamentMatch(
                    tid: playOff.tid,
                    category: playOff.category,
                    isPredicted: true,
                    isPlayOff: true,
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
                    isPredicted: true,
                    isPlayOff: true,
                  ),
                ),
              );
              playOff.predictedMatches = matches;
            } else {
              final List<TournamentMatch> matches = [];
              for (int i = 0; i < 1; i++) {
                matches.add(
                  TournamentMatch(
                    tid: playOff.tid,
                    category: playOff.category,
                    isPredicted: true,
                    isPlayOff: true,
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
                    isPredicted: true,
                    isPlayOff: true,
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
    );
  }
}
