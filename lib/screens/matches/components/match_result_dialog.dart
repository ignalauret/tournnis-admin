import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../models/tournament_match.dart';
import '../../../providers/matches_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class MatchResultDialog extends StatefulWidget {
  MatchResultDialog(this.match);
  final TournamentMatch match;

  @override
  _MatchResultDialogState createState() => _MatchResultDialogState();
}

class _MatchResultDialogState extends State<MatchResultDialog> {
  final scoreController = TextEditingController();
  bool tapped = false;
  bool error = false;

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

  bool checkResultFormat(String result) {
    final sets = result.split(" ");
    if (sets.length != 2 && sets.length != 3) {
      return false;
    }
    for (String set in sets) {
      final games = set.split(".");
      if (games.length != 2) return false;
      try {
        int.parse(games[0]);
        int.parse(games[1]);
      } catch (e) {
        return false;
      }
    }
    return true;
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
          if (error)
            Text(
              "Formato incorrecto",
              style: TextStyle(color: Colors.red),
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
                    if (checkResultFormat(scoreController.text)) {
                      setState(() {
                        error = false;
                        tapped = true;
                      });
                      context
                          .read<MatchesProvider>()
                          .addResult(
                            context,
                            widget.match,
                            scoreController.text,
                          )
                          .then((value) {
                        Navigator.of(context).pop();
                      });
                    } else {
                      setState(() {
                        error = true;
                      });
                    }
                  },
          ),
        ),
      ],
    );
  }
}
