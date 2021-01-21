import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class PlayerTournamentStatsSection extends StatelessWidget {
  PlayerTournamentStatsSection(this.player, this.selectedCategory);
  final Player player;
  final int selectedCategory;
  @override
  Widget build(BuildContext context) {
    final playerRecord = context.select<MatchesProvider, Map<String, int>>(
      (data) => data.getPlayerAnnualResultsOnCategory(
        player.id,
        selectedCategory,
      ),
    );

    return Container(
      height: 170,
      child: FutureBuilder<int>(
        future: context
            .watch<PlayersProvider>()
            .getPlayerGlobalRanking(player.id, selectedCategory),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: context.select<MatchesProvider, bool>((data) => data
                      .getMatchesOfPlayerOnCategory(player.id, selectedCategory)
                      .isEmpty)
                  ? Container(
                      height: 170,
                      child: Center(
                        child: Text(
                          "No jugó esta categoría",
                          style: CustomStyles.kSubtitleStyle,
                        ),
                      ),
                    )
                  : _buildStatsSection(
                      ranking: snapshot.data.toString(),
                      points: player
                          .getPointsOfCategory(selectedCategory)
                          .toString(),
                      titles: context
                          .watch<MatchesProvider>()
                          .getPlayerTitlesOnCategory(
                              player.id, selectedCategory)
                          .toString(),
                      matchesRecord:
                          "${playerRecord["wins"]}-${playerRecord["loses"] + playerRecord["superTiebreaks"]}",
                      setsRecord:
                          "${playerRecord["winSets"]}-${playerRecord["loseSets"]}",
                      gamesRecord:
                          "${playerRecord["winGames"]}-${playerRecord["loseGames"]}",
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

  Widget _buildStatsSection(
      {String ranking,
      String points,
      String titles,
      String matchesRecord,
      String setsRecord,
      String gamesRecord}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat("Ranking", ranking),
            _buildStat("Puntos", points),
            _buildStat("Títulos", titles),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat("Partidos", matchesRecord),
            _buildStat("Sets", setsRecord),
            _buildStat("Games", gamesRecord),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: TextStyle(
                  color: CustomColors.kSelectedItemColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                )),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: CustomStyles.kResultStyle
                  .copyWith(color: CustomColors.kUnselectedItemColor),
            ),
          ),
        ],
      ),
    );
  }
}
