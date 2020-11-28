import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/menu_button.dart';
import '../../models/play_off.dart';
import '../../models/tournament_match.dart';
import '../../providers/play_offs_provider.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

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
                ? MenuButton(
                    "Cancelar PlayOff",
                    () {
                      context
                          .read<PlayOffsProvider>()
                          .deletePlayOff(context, playOff)
                          .then(
                            (value) => Navigator.of(context).pop(),
                          );
                    },
                    letterColor: Colors.red,
                  )
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
