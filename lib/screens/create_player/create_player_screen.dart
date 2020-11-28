import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/action_button.dart';
import '../../components/custom_text_field.dart';
import '../../models/player.dart';
import '../../providers/players_provider.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/custom_styles.dart';

class CreatePlayerScreen extends StatefulWidget {
  static const routeName = "/create-player";
  @override
  _CreatePlayerScreenState createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends State<CreatePlayerScreen> {
  final nameController = TextEditingController();
  final clubController = TextEditingController();

  String selectedHand = "Derecha";
  String selectedBackhand = "Dos manos";

  bool isEdit = false;
  Player player;

  @override
  void dispose() {
    nameController.dispose();
    clubController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (player == null) {
      player = ModalRoute.of(context).settings.arguments;
      if (player != null) {
        setState(() {
          isEdit = true;
          nameController.text = player.name;
          clubController.text = player.club;
          selectedHand =
              player.handed == Handed.Right ? "Derecha" : "Izquierda";
          selectedBackhand =
              player.backhand == Backhand.OneHanded ? "Una mano" : "Dos manos";
        });
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          isEdit ? "Editar Jugador" : "Nuevo jugador",
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        label: "Nombre",
                        hint: "Ingrese el nombre del jugador",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: clubController,
                        label: "Club",
                        hint: "Ingrese el nombre del club",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildSelector("Derecha", "Izquierda", selectedHand,
                          (hand) {
                        setState(() {
                          selectedHand = hand;
                        });
                      }, size),
                      SizedBox(
                        height: 20,
                      ),
                      _buildSelector("Dos manos", "Una mano", selectedBackhand,
                          (backhand) {
                        setState(() {
                          selectedBackhand = backhand;
                        });
                      }, size),
                    ],
                  ),
                ),
              ),
              ActionButton(
                isEdit ? "Guardar" : "Agregar",
                () {
                  if (isEdit)
                    context
                        .read<PlayersProvider>()
                        .editPlayer(
                          player.id,
                          nameController.text,
                          clubController.text,
                          selectedHand == "Derecha"
                              ? Handed.Right
                              : Handed.Left,
                          selectedBackhand == "Dos manos"
                              ? Backhand.TwoHanded
                              : Backhand.OneHanded,
                        )
                        .then(
                          (value) => Navigator.of(context).pop(),
                        );
                  else
                    context
                        .read<PlayersProvider>()
                        .createPlayer(
                          name: nameController.text,
                          club: clubController.text,
                          hand: selectedHand == "Derecha"
                              ? Handed.Right
                              : Handed.Left,
                          backhand: selectedBackhand == "Dos manos"
                              ? Backhand.TwoHanded
                              : Backhand.OneHanded,
                        )
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                },
                enabled: nameController.text.isNotEmpty &&
                    clubController.text.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSelector(String option1, String option2, String selected,
      Function select, Size size) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSelectorButton(option1, option1 == selected, select, size),
        SizedBox(
          width: 20,
        ),
        _buildSelectorButton(option2, option2 == selected, select, size),
      ],
    );
  }

  Widget _buildSelectorButton(
      String label, bool selected, Function select, Size size) {
    return GestureDetector(
      onTap: () {
        select(label);
      },
      child: Container(
        width: size.width * 0.35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? CustomColors.kAccentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          border: Border.all(color: CustomColors.kAccentColor, width: 2),
        ),
        padding: const EdgeInsets.all(15),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: CustomStyles.kPlayerNameStyle.copyWith(
              color: selected ? Colors.white : CustomColors.kAccentColor,
            ),
          ),
        ),
      ),
    );
  }
}
