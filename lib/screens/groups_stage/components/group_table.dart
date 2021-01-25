import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/screens/player_detail/player_detail_screen.dart';

import '../../../models/group_zone.dart';
import '../../../providers/matches_provider.dart';
import '../../../providers/players_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class GroupTable extends StatelessWidget {
  GroupTable(this.group, this.tapPlayers);
  final GroupZone group;
  final bool tapPlayers;

  @override
  Widget build(BuildContext context) {
    final playerData = context.watch<PlayersProvider>();
    final matchesData = context.watch<MatchesProvider>();
    final List<String> orderedPids = group.playersIds
      ..sort((pid1, pid2) => matchesData.comparePlayersWithPid(
          context, group.tid, group.category, pid1, pid2));

    return Container(
      decoration: BoxDecoration(
        color: CustomColors.kCardBackgroundColor,
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: Column(
        children: List.generate(group.playersIds.length, (index) => index)
            .map(
              (index) => _buildPlayerRow(
                context,
                group.tid,
                tapPlayers,
                index,
                orderedPids,
                playerData,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPlayerRow(BuildContext context, String tid, bool tapPlayers,
      int index, List<String> orderedPids, PlayersProvider playersData) {
    return GestureDetector(
      onTap: !tapPlayers
          ? null
          : () {
              Navigator.of(context).pushNamed(PlayerDetailScreen.routeName,
                  arguments: {
                    "player": playersData.getPlayerById(orderedPids[index]),
                    "tid": tid
                  });
            },
      child: Row(
        children: [
          Container(
            height: 30,
            width: 35,
            decoration: BoxDecoration(
              color: CustomColors.kAccentColor,
              borderRadius: BorderRadius.only(
                  topLeft: index == 0
                      ? Radius.circular(Constants.kCardBorderRadius)
                      : Radius.zero,
                  bottomLeft: index == orderedPids.length - 1
                      ? Radius.circular(Constants.kCardBorderRadius)
                      : Radius.zero),
            ),
            alignment: Alignment.center,
            child: FutureBuilder<int>(
                future: playersData.getPlayerGlobalRanking(
                    orderedPids[index], group.category),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data == 0 ? "-" : snapshot.data.toString(),
                      style: CustomStyles.kResultStyle.copyWith(
                        color: CustomColors.kWhiteColor,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                context.select<PlayersProvider, String>(
                    (data) => data.getPlayerName(orderedPids[index])),
                style: index > 1
                    ? CustomStyles.kLighterPlayerNameStyle
                    : CustomStyles.kPlayerNameStyle,
              ),
            ),
          ),
          Container(
            width: 100,
            height: 30,
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              context.select<PlayersProvider, String>((data) =>
                  data
                      .getPlayerTournamentPoints(
                          orderedPids[index], group.tid, group.category)
                      .toString() +
                  " pts"),
              style: index > 1
                  ? CustomStyles.kLighterResultStyle
                  : CustomStyles.kResultStyle,
            ),
          ),
        ],
      ),
    );
  }
}
