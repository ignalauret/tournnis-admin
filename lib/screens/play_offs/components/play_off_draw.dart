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
  void _createGroupZoneDraw(GroupsProvider groupsData, PlayOff playOff) {
    final players =
        groupsData.getGroupsWinners(context, playOff.tid, playOff.category);
    // If there are not 8 groups, cant build predictions.
    if (players.length != 16) return;
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

  // void _createLeagueDraw(List<Player> ranking) {
  //   final List<TournamentMatch> matches = [];
  //   for (int i = 0; i < Utils.pow2(playOff.nRounds - 1) - 1; i++) {
  //     matches.add(
  //       TournamentMatch(
  //         tid: playOff.tid,
  //         category: playOff.category,
  //         isPredicted: true,
  //         isPlayOff: true,
  //       ),
  //     );
  //   }
  //   matches.addAll(
  //     List.generate(
  //       Utils.pow2(playOff.nRounds - 1),
  //       (index) => TournamentMatch(
  //         pid1: ranking[kMatchOrder[2 * index]].id,
  //         pid2: ranking[kMatchOrder[2 * index + 1]].id,
  //         category: playOff.category,
  //         tid: playOff.tid,
  //         isPredicted: true,
  //         isPlayOff: true,
  //       ),
  //     ),
  //   );
  //   playOff.predictedMatches = matches;
  // }

  @override
  Widget build(BuildContext context) {
    final PlayOff playOff = ModalRoute.of(context).settings.arguments;
    final GroupsProvider groupsData = context.watch<GroupsProvider>();
    if (!playOff.hasStarted) _createGroupZoneDraw(groupsData, playOff);

    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          playOff.hasStarted
              ? TournamentMatch.getCategoryName(playOff.category)
              : "Predicción " +
                  TournamentMatch.getCategoryName(playOff.category),
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: CustomColors.kAccentColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditPlayOffScreen.routeName, arguments: playOff);
              }),
        ],
      ),
      body: Draw(playOff),
    );
  }
}
