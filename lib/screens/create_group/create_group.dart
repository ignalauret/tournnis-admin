import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/category_selector.dart';

import '../../components/action_button.dart';
import '../../components/custom_text_field.dart';
import '../../components/text_data_card.dart';
import '../../models/group_zone.dart';
import '../../providers/groups_provider.dart';
import '../../screens/select_player/select_player_screen.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class CreateGroup extends StatefulWidget {
  static const routeName = "/create-group";
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  int selectedCategory = 0;
  final nameController = TextEditingController();
  final indexController = TextEditingController();
  int players = 4;
  List<String> pids = [null, null, null, null];
  List<String> names = [null, null, null, null];
  String tid;

  @override
  void didChangeDependencies() {
    tid = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    indexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Nuevo Grupo",
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CategorySelector(
                        selectedCat: selectedCategory,
                        select: (cat) {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        options: [0, 1, 2, 3],
                      ),
                      CustomTextField(
                        controller: nameController,
                        label: "Nombre",
                        hint: "Ingrese el nombre del grupo",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        controller: indexController,
                        label: "Número",
                        hint: "Ingrese el número del grupo",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildPlayersTitle(),
                      ...List.generate(names.length, (index) => index)
                          .map(
                            (i) => _buildPlayerSelector(size, i),
                          )
                          .toList()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ActionButton(
                "Agregar",
                () {
                  context
                      .read<GroupsProvider>()
                      .createGroup(
                        context,
                        GroupZone(
                          tid: tid,
                          name: nameController.text,
                          category: selectedCategory,
                          playersIds: pids,
                          index: int.parse(indexController.text) - 1,
                        ),
                      )
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                },
                enabled: !pids.any((pid) => pid == null) &&
                    nameController.text.isNotEmpty &&
                    indexController.text.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildPlayersTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            if (players > 2)
              setState(() {
                players--;
                pids.removeLast();
                names.removeLast();
              });
          },
          child: Container(
            height: 30,
            width: 30,
            child: Icon(
              Icons.remove,
              color: CustomColors.kAccentColor,
            ),
          ),
        ),
        Text(
          "$players Jugadores",
          style: CustomStyles.kTitleStyle,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              players++;
              pids.add(null);
              names.add(null);
            });
          },
          child: Container(
            height: 30,
            width: 30,
            child: Icon(
              Icons.add,
              color: CustomColors.kAccentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerSelector(Size size, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: TextDataCard(
        title: "Jugador ${index + 1}",
        data: names[index] == null ? "Seleccionar jugador" : names[index],
        size: size,
        onTap: () {
          Navigator.of(context).pushNamed(SelectPlayerScreen.routeName).then(
            (value) {
              if (value == null) return;
              final Map<String, String> map = value;
              setState(() {
                pids[index] = map["id"];
                names[index] = map["name"];
              });
            },
          );
        },
      ),
    );
  }
}
