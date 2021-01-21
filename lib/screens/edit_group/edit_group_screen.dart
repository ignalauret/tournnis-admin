import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/menu_button.dart';
import '../../models/group_zone.dart';
import '../../providers/groups_provider.dart';
import '../../screens/edit_group/components/add_player_dialog.dart';
import '../../screens/edit_group/components/change_name_dialog.dart';
import '../../screens/edit_group/components/delete_player_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class EditGroupScreen extends StatelessWidget {
  static const routeName = "/edit-group";

  @override
  Widget build(BuildContext context) {
    final GroupZone group = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Editar ${group.name}",
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MenuButton("Cambiar nombre", () {
                showDialog(
                        context: context,
                        builder: (context) => ChangeNameDialog(group))
                    .then((success) {
                  if (success ?? false) Navigator.of(context).pop();
                });
              }),
              MenuButton("Agregar Jugador", () {
                showDialog(
                        context: context,
                        builder: (context) => AddPlayerDialog(group))
                    .then((success) {
                  if (success ?? false) Navigator.of(context).pop();
                });
              }),
              MenuButton("Eliminar Jugador", () {
                showDialog(
                        context: context,
                        builder: (context) => DeletePlayerDialog(group))
                    .then((success) {
                  if (success ?? false) Navigator.of(context).pop();
                });
              }),
              MenuButton(
                "Eliminar Grupo",
                () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Seguro que desea eliminar este grupo?",
                        style: CustomStyles.kNormalStyle,
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
                    if (deleted) Navigator.of(context).pop(true);
                  });
                },
                letterColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
