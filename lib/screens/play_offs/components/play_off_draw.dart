import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/play_off.dart';
import '../../../models/player.dart';
import '../../../models/tournament_match.dart';
import '../../../providers/groups_provider.dart';
import '../../../providers/players_provider.dart';
import '../../../screens/edit_play_off/edit_play_off_screen.dart';
import '../../../utils/colors.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/utils.dart';

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

    void _createGroupZoneDraw(GroupsProvider groupsData) {
      final players =
          groupsData.getGroupsWinners(context, playOff.tid, playOff.category);
      final List<TournamentMatch> matches = [];
      for (int i = 0; i < Utils.pow2(playOff.nRounds - 1) - 1; i++) {
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
    }

    void _createLeagueDraw(List<Player> ranking) {
      final List<TournamentMatch> matches = [];
      for (int i = 0; i < Utils.pow2(playOff.nRounds - 1) - 1; i++) {
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
            pid1: ranking[kMatchOrder[2 * index]].id,
            pid2: ranking[kMatchOrder[2 * index + 1]].id,
            category: playOff.category,
            tid: playOff.tid,
            isPredicted: true,
            isPlayOff: true,
          ),
        ),
      );
      playOff.predictedMatches = matches;
    }

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
              _createGroupZoneDraw(groupsData);
            } else {
              _createLeagueDraw(snapshot.data);
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
