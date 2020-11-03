import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/screens/group_matches/group_matches_screen.dart';
import 'package:tournnis_admin/screens/groups_stage/components/group_table.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class GroupsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GroupZone>>(
      future: context.watch<GroupsProvider>().groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                GroupMatchesScreen.routeName,
                arguments: snapshot.data[index],
              ),
              child: GroupsListItem(snapshot.data[index]),
            ),
            itemCount: snapshot.data.length,
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
  GroupsListItem(this.group);
  final GroupZone group;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.kMainColor,
        borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
      ),
      child: Column(
        children: [
          _buildHeader(group.name, group.categoryName),
          GroupTable(group),
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
            width: 45,
          ),
          Text(
            name,
            style: CustomStyles.kResultStyle.copyWith(
              color: Colors.white,
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
