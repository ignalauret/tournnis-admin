import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/action_button.dart';
import 'package:tournnis_admin/components/custom_text_field.dart';
import 'package:tournnis_admin/components/text_data_card.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/screens/select_player/select_player_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class CreateGroup extends StatefulWidget {
  static const routeName = "/create-group";
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  int selectedCategory = 0;
  final nameController = TextEditingController();
  int players = 4;
  List<String> pids = [null, null, null, null];
  List<String> names = [null, null, null, null];

  bool isEdit = false;
  String tid;

  @override
  void didChangeDependencies() {
    final Map<String, dynamic> data = ModalRoute.of(context).settings.arguments;
    tid = data["tid"];
    final Map<String, dynamic> editData = data["editData"];
    if (editData != null) {
      setState(() {
        isEdit = true;
        nameController.text = editData["name"];
        pids = editData["pids"];
        names = editData["names"];
        players = pids.length;
        //selectedCategory = editData["category"];
      });
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
        title: Text(isEdit ? "Editar grupo" : "Nuevo grupo", style: CustomStyles.kAppBarTitle,),
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
                      // CategorySelector(
                      //   selectedCat: selectedCategory,
                      //   select: (cat) {
                      //     setState(() {
                      //       selectedCategory = cat;
                      //     });
                      //   },
                      // ),
                      CustomTextField(
                        controller: nameController,
                        label: "Nombre",
                        hint: "Ingrese el nombre del grupo",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: () {
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
                      ),
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
                isEdit ? "Guardar" : "Agregar",
                () {
                  if (isEdit) {
                  } else {
                    context
                        .read<GroupsProvider>()
                        .createGroup(
                          context,
                          GroupZone(
                            tid: tid,
                            name: nameController.text,
                            category: selectedCategory,
                            playersIds: pids,
                          ),
                        )
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  }
                },
                enabled: !pids.any((pid) => pid == null) &&
                    nameController.text.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
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
