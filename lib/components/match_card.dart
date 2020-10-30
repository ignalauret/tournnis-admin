import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class MatchCard extends StatelessWidget {
  MatchCard(this.match);
  final TournamentMatch match;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<PlayersProvider>(
      builder: (context, playersData, _) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Container(
              height: 30,
              width: size.width * 0.85,
              child: Row(
                children: [
                  SizedBox(
                    width: 35,
                  ),
                  Text(
                    DateFormat.MMMEd().add_jm().format(match.date),
                    style: CustomStyles.kResultStyle.copyWith(
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Spacer(),
                  Text(
                    match.categoryName,
                    style: CustomStyles.kCategoryStyle,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(Constants.kCardBorderRadius),
              ),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 30,
                    decoration: BoxDecoration(
                      color: CustomColors.kAccentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Constants.kCardBorderRadius),
                        bottomLeft:
                            Radius.circular(Constants.kCardBorderRadius),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRanking(5),
                        _buildRanking(1),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildPlayerRow(
                            playersData.getPlayerName(match.pid1),
                            match.result1,
                            !match.isSecondWinner,
                          ),
                        ),
                        Expanded(
                          child: _buildPlayerRow(
                            playersData.getPlayerName(match.pid2),
                            match.result2,
                            !match.isFirstWinner,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRanking(int ranking) {
    return Container(
      height: 35,
      width: 30,
      alignment: Alignment.center,
      child: Text(
        ranking.toString(),
        style: CustomStyles.kResultStyle.copyWith(color: Colors.white),
      ),
    );
  }

  Row _buildPlayerRow(String name, List<int> score, bool isWinner) {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            name,
            style: CustomStyles.kPlayerNameStyle.copyWith(
              color: isWinner ? null : CustomColors.kMainColor.withOpacity(0.5),
            ),
          ),
        ),
        if (score != null)
          ...score.map(
            (score) => Container(
              height: 35,
              width: 30,
              alignment: Alignment.center,
              child: Text(
                score.toString(),
                style: CustomStyles.kResultStyle.copyWith(
                  color: isWinner
                      ? null
                      : CustomColors.kMainColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
