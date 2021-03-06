import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/group_zone.dart';
import '../../../providers/groups_provider.dart';
import '../../../screens/group_matches/group_matches_screen.dart';
import '../../../screens/groups_stage/components/group_table.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class GroupsList extends StatelessWidget {
  GroupsList(this.selectedCategory, this.tid);
  final int selectedCategory;
  final String tid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GroupZone>>(
      future: context.watch<GroupsProvider>().groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<GroupZone> groupsList = snapshot.data
              .where((group) =>
                  (group.category == selectedCategory ||
                      selectedCategory == 4) &&
                  group.tid == tid)
              .toList();
          groupsList.sort((g1, g2) => g1.index.compareTo(g2.index));
          return groupsList.isEmpty
              ? Center(
                  child: Text(
                    "Esta categoría no ha comenzado aún",
                    style: CustomStyles.kSubtitleStyle,
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      GroupMatchesScreen.routeName,
                      arguments: groupsList[index],
                    ),
                    child: GroupsListItem(groupsList[index], false),
                  ),
                  itemCount: groupsList.length,
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

class GroupsListItem extends StatelessWidget {
  GroupsListItem(this.group, this.tapPlayers);
  final GroupZone group;
  final bool tapPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: Column(
        children: [
          _buildHeader(group.name, group.categoryName),
          GroupTable(group, tapPlayers),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Container _buildHeader(String name, String category) {
    return Container(
      height: 30,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 40,
          ),
          Text(
            name,
            style: CustomStyles.kResultStyle.copyWith(
              color: CustomColors.kAccentColor,
              letterSpacing: -0.5,
            ),
          ),
          Spacer(),
          Text(
            category,
            style: CustomStyles.kCategoryStyle,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}
