import 'dart:math';

import 'package:diagonal_scrollview/diagonal_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/match_card.dart';
import '../../../models/play_off.dart';
import '../../../providers/matches_provider.dart';
import '../../../utils/custom_styles.dart';
import '../../../utils/utils.dart';

const kRoundNames = [
  "Final",
  "Semifinal",
  "Cuartos de final",
  "Octavos de final"
];

const kMatchCardMargin = 20.0;

class Draw extends StatelessWidget {
  Draw(this.playOff);

  final PlayOff playOff;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final matchesProvider = context.watch<MatchesProvider>();
    return !playOff.hasStarted && playOff.predictedMatches == null
        ? Center(
            child: Text(
              "Esta categoría no comenzó aún",
              style: CustomStyles.kSubtitleStyle,
            ),
          )
        : DiagonalScrollView(
            maxHeight: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
            maxWidth:
                (size.width * 0.85 + 2 * kMatchCardMargin) * playOff.nRounds,
            enableZoom: true,
            child: Container(
              height: Utils.pow2(playOff.nRounds - 1) * 110.0 + 30,
              width:
                  (size.width * 0.85 + 2 * kMatchCardMargin) * playOff.nRounds,
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

  Column _buildRoundColumn(
      MatchesProvider matchesData, PlayOff playOff, int round) {
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
                height: 100,
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: max(
                      0,
                      50.0 +
                          (playOff.nRounds - round - 2) * 100 +
                          max(0, (playOff.nRounds - round - 3)) * 100),
                ),
                child: MatchCard(matchesData.getMatchById(mid)),
              ),
            )
            .toList(),
      ],
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
                height: 100,
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: max(
                      0,
                      50.0 +
                          (playOff.nRounds - round - 2) * 100 +
                          max(0, (playOff.nRounds - round - 3)) * 100),
                ),
                child: MatchCard(match),
              ),
            )
            .toList(),
      ],
    );
  }
}
