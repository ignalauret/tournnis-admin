import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class GroupTable extends StatelessWidget {
  GroupTable(this.group);
  final GroupZone group;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.kWhiteColor,
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: Column(
        children: List.generate(group.playersIds.length, (index) => index)
            .map((e) => _buildPlayerRow(context, e))
            .toList(),
      ),
    );
  }

  Row _buildPlayerRow(BuildContext context, int index) {
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
                bottomLeft: index == group.playersIds.length - 1
                    ? Radius.circular(Constants.kCardBorderRadius)
                    : Radius.zero),
          ),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: CustomStyles.kResultStyle.copyWith(
              color: CustomColors.kWhiteColor,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            context.select<PlayersProvider, String>(
                (data) => data.getPlayerName(group.playersIds[index])),
            style: index > 1
                ? CustomStyles.kPlayerNameStyle
                    .copyWith(color: CustomColors.kMainColor.withOpacity(0.5))
                : CustomStyles.kPlayerNameStyle,
          ),
        ),
        Container(
          width: 100,
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(
            "250 puntos",
            style: index > 1
                ? CustomStyles.kResultStyle
                    .copyWith(color: CustomColors.kMainColor.withOpacity(0.5))
                : CustomStyles.kResultStyle,
          ),
        ),
      ],
    );
  }
}
