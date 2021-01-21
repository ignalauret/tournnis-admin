import 'package:flutter/material.dart';

import '../../models/group_zone.dart';
import '../../screens/edit_group/edit_group_screen.dart';
import '../../screens/group_matches/components/group_matches_list.dart';
import '../../screens/groups_stage/components/groups_list.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class GroupMatchesScreen extends StatelessWidget {
  static const routeName = "/group-matches";
  @override
  Widget build(BuildContext context) {
    final GroupZone group = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          group.name,
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: CustomColors.kAccentColor,
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
              GroupsListItem(group, true),
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
