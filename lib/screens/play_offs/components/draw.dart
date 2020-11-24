import 'dart:math';

import 'package:diagonal_scrollview/diagonal_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/play_off.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';
import 'package:tournnis_admin/utils/utils.dart';

const kRoundNames = [
  "Final",
  "Semifinal",
  "Cuartos de final",
  "Octavos de final"
];

class Draw extends StatelessWidget {
  Draw(this.playOff);
  final PlayOff playOff;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final matchesProvider = context.watch<MatchesProvider>();
    return DiagonalScrollView(
      maxHeight: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
      maxWidth: (size.width * 0.85 + 20) * playOff.nRounds,
      child: Container(
        height: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
        width: (size.width * 0.85 + 20) * playOff.nRounds,
        child: Row(
          children: List.generate(
            playOff.nRounds,
            (index) => playOff.hasStarted
                ? _buildRoundColumn(
                    matchesProvider, playOff, playOff.nRounds - index - 1)
                : _buildPredictedRoundColumn(
                    playOff, playOff.nRounds - index - 1),
          ).toList(),
        ),
      ),
    );
  }
}

Column _buildRoundColumn(
    MatchesProvider matchesData, PlayOff playOff, int round) {
  return Column(
    children: playOff
        .getMatchesOfRound(round)
        .map(
          (mid) => Container(
            height: 110,
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: max(
                  0,
                  55.0 +
                      (playOff.nRounds - round - 2) * 110 +
                      max(0, (playOff.nRounds - round - 3)) * 110),
            ),
            child: MatchCard(matchesData.getMatchById(mid)),
          ),
        )
        .toList(),
  );
}

Column _buildPredictedRoundColumn(PlayOff playOff, int round) {
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
          .getPredictedMatchesOfRound(round)
          .map(
            (match) => Container(
              height: 110,
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: max(
                    0,
                    55.0 +
                        (playOff.nRounds - round - 2) * 110 +
                        max(0, (playOff.nRounds - round - 3)) * 110),
              ),
              child: MatchCard(match),
            ),
          )
          .toList(),
    ],
  );
}
