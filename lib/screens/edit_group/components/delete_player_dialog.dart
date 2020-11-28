import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/group_zone.dart';
import '../../../providers/groups_provider.dart';
import '../../../providers/players_provider.dart';
import '../../../screens/select_player/components/players_list.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class DeletePlayerDialog extends StatefulWidget {
  DeletePlayerDialog(this.group);

  final GroupZone group;
  @override
  _DeletePlayerDialogState createState() => _DeletePlayerDialogState();
}

class _DeletePlayerDialogState extends State<DeletePlayerDialog> {
  String selectedPid;
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.kMainColor,
      title: Text(
        "Eliminar Jugador",
        style: CustomStyles.kTitleStyle,
      ),
      content: Container(
        child: Consumer<PlayersProvider>(
          builder: (context, playerData, _) {
            final players = [...widget.group.playersIds];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: players
                  .map(
                    (pid) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPid = pid;
                        });
                      },
                      child: PlayersListItem(
                          player: playerData.getPlayerById(pid),
                          selected: pid == selectedPid),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      actions: [
        SizedBox(
          height: 40,
          child: FlatButton(
            child: Text(
              "Cancelar",
              style: CustomStyles.kResultStyle.copyWith(color: Colors.white70),
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
                  color: tapped || selectedPid == null
                      ? Colors.white
                      : CustomColors.kAccentColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            disabledColor: Colors.white38,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: tapped || selectedPid == null
                ? null
                : () {
                    setState(() {
                      tapped = true;
                    });
                    context
                        .read<GroupsProvider>()
                        .removePlayerOfGroup(
                          context,
                          widget.group.id,
                          selectedPid,
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
