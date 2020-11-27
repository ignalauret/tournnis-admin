import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/components/menu_button.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/screens/match_options/components/delete_match_dialog.dart';
import 'package:tournnis_admin/screens/matches/components/match_result_dialog.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class MatchOptionsScreen extends StatelessWidget {
  static const routeName = "/match-options";

  Future<void> _setMatchDate(
      BuildContext context, TournamentMatch match) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      helpText: "Elegir fecha del partido",
      confirmText: "Confirmar",
      cancelText: "Cancelar",
    );
    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        confirmText: "Confirmar",
        cancelText: "Cancelar",
        helpText: "Elegir hora del partido",
      );
      if (pickedTime != null) {
        context.read<MatchesProvider>().addDate(
              match,
              DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                  pickedTime.hour, pickedTime.minute),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TournamentMatch match = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text("Partido", style: CustomStyles.kAppBarTitle,),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MatchCard(match),
            SizedBox(
              width: double.infinity,
            ),
            Spacer(),
            MenuButton(
              match.date == null ? "Programar" : "Reprogramar",
              () => _setMatchDate(context, match),
            ),
            if (match.date != null)
              MenuButton(
                match.hasEnded ? "Editar resultado" : "Agregar resultado",
                () => showDialog(
                  context: context,
                  builder: (context) => MatchResultDialog(match),
                ),
              ),
            if (match.category != 0 && !match.isPlayOff)
              MenuButton(
                "Eliminar partido",
                () {
                  showDialog(
                          context: context,
                          builder: (context) => DeleteMatchDialog(match))
                      .then((deleted) {
                    if (deleted) Navigator.of(context).pop();
                  });
                },
                letterColor: Colors.red,
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
