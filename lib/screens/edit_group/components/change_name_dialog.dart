import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/custom_text_field.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

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
      backgroundColor: CustomColors.kMainColor,
      title: Text("Cambiar nombre", style: CustomStyles.kTitleStyle,),
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
              style: CustomStyles.kResultStyle.copyWith(color:  Colors.white70),
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
              style: CustomStyles.kResultStyle.copyWith(color: tapped || controller.text.isEmpty ? Colors.white : CustomColors.kAccentColor),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            disabledColor: Colors.white38,
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
