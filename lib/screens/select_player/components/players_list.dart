import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class PlayersList extends StatelessWidget {
  PlayersList({
    this.search = "",
    this.selectedId,
    this.select,
    this.showPoints = false,
    this.selectedCategory,
    this.tid,
  });

  final String tid;
  final String selectedId;
  final String search;
  final Function(Player) select;
  final bool showPoints;
  final int selectedCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: context.watch<PlayersProvider>().players,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Player> searchedPlayers = snapshot.data
              .where((player) => player.name.toLowerCase().contains(search))
              .toList();
          if (showPoints)
            searchedPlayers.sort(
              (p1, p2) => p2
                  .getTournamentPointsOfCategory(tid, selectedCategory)
                  .compareTo(
                    p1.getTournamentPointsOfCategory(tid, selectedCategory),
                  ),
            );
          return ListView.builder(
            itemBuilder: (context, index) {
              final player = searchedPlayers[index];
              return GestureDetector(
                onTap: () {
                  if (select != null) select(player);
                },
                child: PlayersListItem(
                  player: player,
                  selected: selectedId == player.id,
                  showPoints: showPoints,
                  selectedCategory: selectedCategory,
                  tid: tid,
                ),
              );
            },
            itemCount: searchedPlayers.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PlayersListItem extends StatelessWidget {
  PlayersListItem({
    this.player,
    this.selected,
    this.showPoints = false,
    this.selectedCategory,
    this.tid,
  });
  final Player player;
  final bool selected;
  final bool showPoints;
  final int selectedCategory;
  final String tid;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              player.name,
              style: CustomStyles.kPlayerNameStyle.copyWith(
                color: selected ? CustomColors.kAccentColor : null,
              ),
            ),
            if (showPoints)
              Text(
                player
                        .getTournamentPointsOfCategory(tid, selectedCategory)
                        .toString() +
                    " puntos",
                style: CustomStyles.kResultStyle.copyWith(
                  color: CustomColors.kAccentColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
