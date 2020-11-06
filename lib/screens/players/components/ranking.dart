import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class Ranking extends StatelessWidget {
  Ranking(this.tid, this.category);
  final String tid;
  final int category;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PlayersProvider>().refreshTournamentCache();
        await context.read<PlayersProvider>().getTournamentRanking(tid, category);
      },
      child: FutureBuilder<List<Player>>(
        future:
            context.watch<PlayersProvider>().getTournamentRanking(tid, category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) => RankingPlayerCard(
                snapshot.data[index],
                index + 1,
                snapshot.data[index].getTournamentPointsOfCategory(tid, category),
                context.watch<MatchesProvider>().getPlayerMatchesFromTournament(snapshot.data[index].id, tid, category),
              ),
              itemCount: snapshot.data.length,
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
      color: CustomColors.kWhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: _buildPlayerRow(player, ranking, points, results),
    );
  }

  Row _buildPlayerRow(Player player, int ranking, int points, Map<String, int> results) {
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
          width: 20,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            results["wins"].toString(),
            style: CustomStyles.kResultStyle,
          ),
        ),
        Container(
          width: 20,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            results["superTiebreaks"].toString(),
            style: CustomStyles.kResultStyle,
          ),
        ),
        Container(
          width: 20,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            results["loses"].toString(),
            style: CustomStyles.kResultStyle,
          ),
        ),
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            points.toString(),
            style: CustomStyles.kResultStyle.copyWith(color: CustomColors.kAccentColor),
          ),
        ),
      ],
    );
  }
}
