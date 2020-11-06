import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/action_button.dart';
import 'package:tournnis_admin/components/category_selector.dart';
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
  List<String> pids = [null, null, null, null];
  List<String> names = [null, null, null, null];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String tid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Nuevo grupo"),
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
                      ),
                      _buildTextField(nameController, "Nombre",
                          "Ingrese el nombre del grupo"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Jugadores",
                        style: CustomStyles.kTitleStyle,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _buildPlayerSelector(size, 0),
                      SizedBox(
                        height: 5,
                      ),
                      _buildPlayerSelector(size, 1),
                      SizedBox(
                        height: 5,
                      ),
                      _buildPlayerSelector(size, 2),
                      SizedBox(
                        height: 5,
                      ),
                      _buildPlayerSelector(size, 3),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
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
                        ),
                      )
                      .then((value) {
                    Navigator.of(context).pop();
                  });
                },
                enabled: !pids.any((pid) => pid == null) && nameController.text.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerSelector(Size size, int index) {
    return TextDataCard(
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
