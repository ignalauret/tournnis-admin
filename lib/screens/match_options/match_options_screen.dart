import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/screens/match_options/components/remove_date_dialog.dart';

import '../../components/match_card.dart';
import '../../components/menu_button.dart';
import '../../models/tournament_match.dart';
import '../../providers/matches_provider.dart';
import '../../screens/matches/components/match_result_dialog.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

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
    final String mid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Partido",
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
        child: Consumer<MatchesProvider>(
          builder: (context, matchesData, _) {
            final TournamentMatch match = matchesData.getMatchById(mid);
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MatchCard(match),
                SizedBox(
                  width: double.infinity,
                ),
                Spacer(),
                if (!match.hasEnded)
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
                if (match.date != null && !match.hasEnded)
                  MenuButton(
                    "Desprogramar",
                    () => showDialog(
                        context: context,
                        builder: (context) => RemoveDateDialog(match.id)),
                  ),
                Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }
}
