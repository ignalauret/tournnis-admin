import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/custom_text_field.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/create_match/create_match_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class MatchResultDialog extends StatefulWidget {
  MatchResultDialog(this.match);
  final TournamentMatch match;

  @override
  _MatchResultDialogState createState() => _MatchResultDialogState();
}

class _MatchResultDialogState extends State<MatchResultDialog> {
  final scoreController = TextEditingController();
  bool tapped = false;

  String parseResult(List<int> res1, List<int> res2) {
    String res = "${res1[0]}.${res2[0]} ${res1[1]}.${res2[1]}";
    if (res1.length == 3) {
      res = res + " ${res1[2]}.${res2[2]}";
    }
    return res;
  }

  @override
  void initState() {
    if (widget.match.hasEnded) {
      setState(() {
        scoreController.text =
            parseResult(widget.match.result1, widget.match.result2);
      });
    }
    scoreController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.kMainColor,
      title: Text(
        widget.match.hasEnded ? "Editar resultado" : "Agregar resultado",
        style: CustomStyles.kTitleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: scoreController,
            label: "Resultado",
            hint: "Ej: 6.2 3.6 7.5",
          ),
        ],
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
              Navigator.of(context).pop();
            },
          ),
        ),
        SizedBox(
          height: 40,
          child: FlatButton(
            child: Text(
              tapped
                  ? "Guardando..."
                  : widget.match.hasEnded
                      ? "Editar"
                      : "Agregar",
              style: CustomStyles.kResultStyle.copyWith(
                  color: tapped || scoreController.text.isEmpty
                      ? Colors.white
                      : CustomColors.kAccentColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            disabledColor: Colors.white38,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: tapped || scoreController.text.isEmpty
                ? null
                : () {
                    setState(() {
                      tapped = true;
                    });
                    context
                        .read<MatchesProvider>()
                        .addResult(widget.match, scoreController.text,
                            context.read<PlayersProvider>())
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
          ),
        ),
      ],
    );
  }
}
