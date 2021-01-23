import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/action_button.dart';
import 'package:tournnis_admin/components/custom_text_field.dart';
import 'package:tournnis_admin/models/tournament.dart';
import 'package:tournnis_admin/providers/tournaments_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class CreateTournamentScreen extends StatefulWidget {
  static const routeName = "/create-tournament";
  @override
  _CreateTournamentScreenState createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  final nameController = TextEditingController();

  bool isEdit = false;
  Tournament editTournament;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    editTournament = ModalRoute.of(context).settings.arguments;
    if (editTournament != null) {
      isEdit = true;
      nameController.text = editTournament.name;
    }
    super.didChangeDependencies();
  }

  void _submit() {
    if (isEdit)
      context
          .read<TournamentsProvider>()
          .editTournament(
            editTournament.id,
            nameController.text,
          )
          .then(
            (value) => Navigator.of(context).pop(),
          );
    else
      context
          .read<TournamentsProvider>()
          .createTournament(
            nameController.text,
          )
          .then((value) => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          isEdit ? "Editar torneo" : "Crear torneo",
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      label: "Nombre",
                      hint: "Ingrese el nombre del torneo",
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ActionButton(
                isEdit ? "Guardar" : "Agregar",
                _submit,
                enabled: nameController.text.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
