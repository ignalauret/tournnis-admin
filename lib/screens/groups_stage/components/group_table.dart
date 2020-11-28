import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/group_zone.dart';
import '../../../providers/matches_provider.dart';
import '../../../providers/players_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class GroupTable extends StatelessWidget {
  GroupTable(this.group);
  final GroupZone group;

  @override
  Widget build(BuildContext context) {
    return Consumer2<MatchesProvider, PlayersProvider>(
      builder: (context, matchesData, playersData, _) {
        final List<String> orderedPids = group.playersIds
          ..sort(
            (pid1, pid2) => matchesData.comparePlayers(
              group.tid,
              group.category,
              playersData.getPlayerById(pid1),
              playersData.getPlayerById(pid2),
            ),
          );
        return Container(
          decoration: BoxDecoration(
            color: CustomColors.kWhiteColor,
            borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          ),
          child: Column(
            children: List.generate(group.playersIds.length, (index) => index)
                .map(
                  (index) => _buildPlayerRow(
                    context,
                    index,
                    orderedPids,
                    playersData,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Row _buildPlayerRow(BuildContext context, int index, List<String> orderedPids,
      PlayersProvider playersData) {
    return Row(
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
              future: playersData.getPlayerRankingFromTournament(
                  context, orderedPids[index], group.tid, group.category),
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
              style: index > group.playersIds.length - 3
                  ? CustomStyles.kPlayerNameStyle
                      .copyWith(color: CustomColors.kMainColor.withOpacity(0.5))
                  : CustomStyles.kPlayerNameStyle,
            ),
          ),
        ),
        Container(
          width: 100,
          height: 30,
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.only(right: 5),
          child: Text(
            context.select<PlayersProvider, String>((data) =>
                data
                    .getPlayerTournamentPoints(
                        orderedPids[index], group.tid, group.category)
                    .toString() +
                " puntos"),
            style: index > group.playersIds.length - 3
                ? CustomStyles.kResultStyle
                    .copyWith(color: CustomColors.kMainColor.withOpacity(0.5))
                : CustomStyles.kResultStyle,
          ),
        ),
      ],
    );
  }
}
