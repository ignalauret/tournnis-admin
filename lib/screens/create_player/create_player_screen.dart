import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/profile_picture.dart';
import 'package:tournnis_admin/components/text_data_card.dart';

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
  final racketController = TextEditingController();

  DateTime birthDate = DateTime(1980, 1, 1);
  String selectedHand = "Derecha";
  String selectedBackhand = "Dos manos";
  String selectedImageUrl;

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
          racketController.text = player.racket;
          selectedHand =
              player.handed == Handed.Right ? "Derecha" : "Izquierda";
          selectedBackhand =
              player.backhand == Backhand.OneHanded ? "Una mano" : "Dos manos";
          selectedImageUrl = player.imageUrl;
          birthDate = player.birth;
        });
      }
    }

    super.didChangeDependencies();
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1940, 8),
      lastDate: DateTime(2020),
      helpText: "Elegir fecha",
      confirmText: "Confirmar",
      cancelText: "Cancelar",
    );
    if (picked != null && picked != birthDate)
      setState(() {
        birthDate = picked;
      });
  }

  void _submit() {
    if (isEdit)
      context
          .read<PlayersProvider>()
          .editPlayer(
            pid: player.id,
            name: nameController.text,
            club: clubController.text,
            hand: selectedHand == "Derecha" ? Handed.Right : Handed.Left,
            backhand: selectedBackhand == "Dos manos"
                ? Backhand.TwoHanded
                : Backhand.OneHanded,
            birthDate: birthDate,
            racket: racketController.text,
            imageUrl: selectedImageUrl,
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
            hand: selectedHand == "Derecha" ? Handed.Right : Handed.Left,
            backhand: selectedBackhand == "Dos manos"
                ? Backhand.TwoHanded
                : Backhand.OneHanded,
            birthDate: birthDate,
            racket: racketController.text,
            imageUrl: selectedImageUrl,
          )
          .then((value) => Navigator.of(context).pop());
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
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: clubController,
                        label: "Club",
                        hint: "Ingrese el nombre del club",
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: racketController,
                        label: "Raqueta",
                        hint: "Ingrese la raqueta del jugador",
                      ),
                      SizedBox(height: 20),
                      TextDataCard(
                        title: "Fecha de nacimiento",
                        data: DateFormat("d/M/y").format(birthDate),
                        size: size,
                        onTap: _selectDate,
                      ),
                      SizedBox(height: 30),
                      _buildSelector(
                        "Derecha",
                        "Izquierda",
                        selectedHand,
                        (hand) {
                          setState(() {
                            selectedHand = hand;
                          });
                        },
                        size,
                      ),
                      SizedBox(height: 20),
                      _buildSelector(
                        "Dos manos",
                        "Una mano",
                        selectedBackhand,
                        (backhand) {
                          setState(() {
                            selectedBackhand = backhand;
                          });
                        },
                        size,
                      ),
                      SizedBox(height: 20),
                      _buildImageSection(size),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              ActionButton(
                isEdit ? "Guardar" : "Agregar",
                _submit,
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
        SizedBox(width: 20),
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

  Column _buildImageSection(Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlatButton(
          onPressed: () async {
            final image =
                await ImagePicker().getImage(source: ImageSource.gallery);
            if (image == null) return;
            final url =
                await context.read<PlayersProvider>().uploadImage(image.path);
            setState(() {
              selectedImageUrl = url;
            });
          },
          child: Text(
            selectedImageUrl == null ? "Subir imágen" : "Cambiar imágen",
            style: CustomStyles.kResultStyle
                .copyWith(color: CustomColors.kAccentColor),
          ),
        ),
        if (selectedImageUrl != null)
          ProfilePicture(
            imagePath: selectedImageUrl,
            diameter: size.width * 0.5,
          ),
      ],
    );
  }
}
