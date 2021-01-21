import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/player_detail/player_detail_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class Ranking extends StatelessWidget {
  Ranking(this.category);
  final int category;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PlayersProvider>().refreshGlobalCache();
        await context.read<PlayersProvider>().getGlobalRanking(category);
      },
      child: FutureBuilder<List<Player>>(
        future: context.watch<PlayersProvider>().getGlobalRanking(category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.isEmpty
                ? Center(
                    child: Text(
                      "Esta categoría no ha comenzado aún",
                      style: CustomStyles.kSubtitleStyle,
                    ),
                  )
                : Column(
                    children: [
                      _buildSubtitles(),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlayerDetailScreen.routeName,
                                  arguments: {
                                    "player": snapshot.data[index],
                                  });
                            },
                            child: RankingPlayerCard(
                              snapshot.data[index],
                              index + 1,
                              snapshot.data[index]
                                  .getPointsOfCategory(category),
                              context
                                  .watch<MatchesProvider>()
                                  .getPlayerTournamentHistory(
                                    snapshot.data[index].id,
                                    category,
                                  ),
                            ),
                          ),
                          itemCount: snapshot.data.length,
                        ),
                      ),
                    ],
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

  Container _buildSubtitles() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          SizedBox(
            height: 20,
            width: 35,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                "Nombre",
                style: CustomStyles.kSubtitleStyle,
              ),
            ),
          ),
          Container(
            width: 25,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 5),
            child: Text(
              "TJ",
              style: CustomStyles.kSubtitleStyle,
            ),
          ),
          Container(
            width: 25,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 5),
            child: Text(
              "TG",
              style: CustomStyles.kSubtitleStyle,
            ),
          ),
          Container(
            width: 35,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 5),
            child: Text(
              "PTS",
              style: CustomStyles.kSubtitleStyle,
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

class RankingPlayerCard extends StatelessWidget {
  RankingPlayerCard(this.player, this.ranking, this.points, this.results);
  final Player player;
  final int ranking;
  final int points;
  final Map<String, int> results;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.kMainColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: _buildPlayerRow(player, ranking, points, results),
    );
  }

  Row _buildPlayerRow(
      Player player, int ranking, int points, Map<String, int> results) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 35,
          decoration: BoxDecoration(
            color: CustomColors.kAccentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constants.kCardBorderRadius),
              bottomLeft: Radius.circular(Constants.kCardBorderRadius),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            ranking.toString(),
            style: CustomStyles.kResultStyle.copyWith(
              color: CustomColors.kWhiteColor,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              player.name,
              style: CustomStyles.kPlayerNameStyle,
            ),
          ),
        ),
        Container(
          width: 25,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            results["played"].toString(),
            style: CustomStyles.kResultStyle,
          ),
        ),
        Container(
          width: 25,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            results["titles"].toString(),
            style: CustomStyles.kResultStyle,
          ),
        ),
        Container(
          width: 35,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            points.toString(),
            style: CustomStyles.kResultStyle
                .copyWith(color: CustomColors.kAccentColor),
          ),
        ),
      ],
    );
  }
}
