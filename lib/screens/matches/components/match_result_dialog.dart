import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
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

  @override
  void initState() {
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
      title: Text(
        "Agregar resultado",
        style: CustomStyles.kTitleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(scoreController, "Resultado", "Ej: 6.2 3.6 7.5"),
        ],
      ),
      actions: [
        SizedBox(
          height: 40,
          child: FlatButton(
            child: Text(
              "Cancelar",
              style: CustomStyles.kResultStyle.copyWith(color: Colors.black54),
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
              tapped ? "Agregando..." : "Agregar",
              style: CustomStyles.kResultStyle.copyWith(color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            color: CustomColors.kAccentColor,
            disabledColor: Colors.black12,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: !tapped || scoreController.text.isEmpty
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

  TextField _buildTextField(
      TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      style: CustomStyles.kNormalStyle.copyWith(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: CustomStyles.kResultStyle
            .copyWith(color: CustomColors.kAccentColor),
        hintText: hint,
        hintStyle: CustomStyles.kNormalStyle.copyWith(color: Colors.black87),
        alignLabelWithHint: true,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.kAccentColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.kAccentColor,
          ),
        ),
      ),
    );
  }
}
