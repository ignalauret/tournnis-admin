import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class RemoveDateDialog extends StatefulWidget {
  RemoveDateDialog(this.mid);
  final String mid;
  @override
  _RemoveDateDialogState createState() => _RemoveDateDialogState();
}

class _RemoveDateDialogState extends State<RemoveDateDialog> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Está seguro que desea desprogramar este partido?"),
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
              tapped ? "Desprogramando..." : "Desprogramar",
              style: CustomStyles.kResultStyle.copyWith(
                  color: tapped
                      ? CustomColors.kAccentColor.withOpacity(0.5)
                      : CustomColors.kAccentColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: tapped
                ? null
                : () {
                    setState(() {
                      tapped = true;
                    });
                    context
                        .read<MatchesProvider>()
                        .removeDate(widget.mid)
                        .then((value) {
                      Navigator.of(context).pop(true);
                    });
                  },
          ),
        ),
      ],
    );
  }
}
