import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/create_group/create_group.dart';
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
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              // final playerData = context.read<PlayersProvider>();
              // Navigator.of(context).pushNamed(
              //   CreateGroup.routeName,
              //   arguments: {
              //     "tid": group.tid,
              //     "editData": {
              //       "name": group.name,
              //       "pids": group.playersIds,
              //       "names": group.playersIds
              //           .map((pid) => playerData.getPlayerName(pid))
              //           .toList(),
              //       //"category": group.category,
              //     }
              //   },
              // );
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Seguro que desea eliminar este grupo?",
                    style: CustomStyles.kResultStyle,
                  ),
                  actions: [
                    FlatButton(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Eliminar",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<GroupsProvider>()
                            .deleteGroup(context, group.id)
                            .then(
                              (value) => Navigator.of(context).pop(true),
                            );
                      },
                    ),
                  ],
                ),
              ).then((deleted) {
                if (deleted) Navigator.of(context).pop();
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
