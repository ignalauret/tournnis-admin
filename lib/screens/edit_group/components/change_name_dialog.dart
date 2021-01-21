import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_text_field.dart';
import '../../../models/group_zone.dart';
import '../../../providers/groups_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_styles.dart';

class ChangeNameDialog extends StatefulWidget {
  ChangeNameDialog(this.group);

  final GroupZone group;
  @override
  _ChangeNameDialogState createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  final controller = TextEditingController();
  bool tapped = false;

  @override
  void initState() {
    setState(() {
      controller.text = widget.group.name;
    });
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.kBackgroundColor,
      title: Text(
        "Cambiar nombre",
        style: CustomStyles.kTitleStyle,
      ),
      content: Container(
        child: CustomTextField(
          controller: controller,
          label: "Nombre",
          hint: "Ingrese el nuevo nombre",
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
                  color: tapped || controller.text.isEmpty
                      ? CustomColors.kAccentColor.withOpacity(0.5)
                      : CustomColors.kAccentColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            onPressed: tapped || controller.text.isEmpty
                ? null
                : () {
                    setState(() {
                      tapped = true;
                    });
                    context
                        .read<GroupsProvider>()
                        .changeGroupName(
                          widget.group.id,
                          controller.text,
                        )
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
