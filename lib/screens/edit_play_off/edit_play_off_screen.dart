import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/menu_button.dart';
import 'package:tournnis_admin/models/play_off.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/play_offs_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class EditPlayOffScreen extends StatelessWidget {
  static const routeName = "/edit-play-off";

  @override
  Widget build(BuildContext context) {
    final PlayOff playOff = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text(
          "Editar " + TournamentMatch.getCategoryName(playOff.category),
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            playOff.hasStarted
                ? MenuButton("Reemplazar jugador", () {})
                : MenuButton("Iniciar PlayOff", () {
                    context
                        .read<PlayOffsProvider>()
                        .createPlayOff(context, playOff)
                        .then((value) => Navigator.of(context).pop());
                  }),
          ],
        ),
      ),
    );
  }
}
