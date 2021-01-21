import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../../components/text_data_card.dart';
import '../../../models/group_zone.dart';
import '../../../providers/groups_provider.dart';
import '../../../screens/select_player/select_player_screen.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class AddPlayerDialog extends StatefulWidget {
  AddPlayerDialog(this.group);

  final GroupZone group;
  @override
  _AddPlayerDialogState createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {
  String name;
  String pid;
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: CustomColors.kBackgroundColor,
      title: Text(
        "Agregar Jugador",
        style: CustomStyles.kTitleStyle,
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextDataCard(
              title: "Nuevo Jugador",
              data: name == null ? "Seleccionar jugador" : name,
              size: size,
              onTap: () {
                Navigator.of(context)
                    .pushNamed(SelectPlayerScreen.routeName)
                    .then(
                  (value) {
                    if (value == null) return;
                    final Map<String, String> map = value;
                    setState(() {
                      pid = map["id"];
                      name = map["name"];
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          height: 40,
          child: FlatButton(
            child: Text(
              "Cancelar",
              style: CustomStyles.kResultStyle.copyWith(color: Colors.grey),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: FlatButton(
            child: Text(
              tapped ? "Guardando..." : "Guardar",
              style: CustomStyles.kResultStyle.copyWith(
                  color: tapped || name == null
                      ? CustomColors.kAccentColor.withOpacity(0.5)
                      : CustomColors.kAccentColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: tapped || name == null
                ? null
                : () {
                    setState(() {
                      tapped = true;
                    });
                    context
                        .read<GroupsProvider>()
                        .addPlayerToGroup(
                          context,
                          widget.group.id,
                          pid,
                        )
                        .then((value) {
                      Navigator.of(context).pop(value);
                    });
                  },
          ),
        ),
      ],
    );
  }
}
