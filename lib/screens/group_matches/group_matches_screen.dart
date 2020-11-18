import 'package:flutter/material.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/screens/edit_group/edit_group_screen.dart';
import 'package:tournnis_admin/screens/group_matches/components/group_matches_list.dart';
import 'package:tournnis_admin/screens/groups_stage/components/groups_list.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class GroupMatchesScreen extends StatelessWidget {
  static const routeName = "/group-matches";
  @override
  Widget build(BuildContext context) {
    final GroupZone group = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: CustomColors.kWhiteColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditGroupScreen.routeName, arguments: group)
                  .then((delete) {
                if (delete ?? false) Navigator.of(context).pop();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              GroupsListItem(group),
              Text(
                "Partidos",
                style: CustomStyles.kTitleStyle,
              ),
              Expanded(
                child: GroupMatchesList(group),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
