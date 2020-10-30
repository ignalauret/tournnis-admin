import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/action_button.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    clubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Nuevo jugador"),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Theme(
            data: ThemeData(
              primaryColor: CustomColors.kAccentColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(
                        nameController,
                        "Nombre",
                        "Ingrese el nombre del jugador",
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _buildTextField(
                        clubController,
                        "Club",
                        "Ingrese el nombre del club",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildSelector(
                        "Derecha",
                        "Izquierda",
                        selectedHand,
                        (hand) {
                          setState(() {
                            selectedHand = hand;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildSelector(
                        "Dos manos",
                        "Una mano",
                        selectedBackhand,
                        (backhand) {
                          setState(() {
                            selectedBackhand = backhand;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ActionButton(
                  "Agregar",
                  () {
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      style: CustomStyles.kNormalStyle,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: CustomStyles.kResultStyle
            .copyWith(color: CustomColors.kAccentColor),
        hintText: hint,
        hintStyle: CustomStyles.kNormalStyle.copyWith(color: Colors.white70),
        alignLabelWithHint: true,
        border: UnderlineInputBorder(
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

  Row _buildSelector(
      String option1, String option2, String selected, Function select) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSelectorButton(option1, option1 == selected, select),
        SizedBox(
          width: 20,
        ),
        _buildSelectorButton(option2, option2 == selected, select),
      ],
    );
  }

  Widget _buildSelectorButton(String label, bool selected, Function select) {
    return GestureDetector(
      onTap: () {
        select(label);
      },
      child: Container(
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? CustomColors.kAccentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
          border: Border.all(color: CustomColors.kAccentColor, width: 2),
        ),
        padding: const EdgeInsets.all(15),
        child: Text(
          label,
          style: CustomStyles.kPlayerNameStyle.copyWith(
            color: selected ? Colors.white : CustomColors.kAccentColor,
          ),
        ),
      ),
    );
  }
}
