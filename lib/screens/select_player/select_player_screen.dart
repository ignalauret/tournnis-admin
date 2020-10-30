import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/search_bar.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/screens/select_player/components/players_list.dart';
import 'package:tournnis_admin/utils/colors.dart';

class SelectPlayerScreen extends StatefulWidget {
  static const routeName = "/select-player";
  @override
  _SelectPlayerScreenState createState() => _SelectPlayerScreenState();
}

class _SelectPlayerScreenState extends State<SelectPlayerScreen> {
  String search = "";
  String selectedId;
  String selectedName;

  void selectPlayer(Player player) {
    setState(() {
      selectedId = player.id;
      selectedName = player.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Seleccionar jugador"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color:
                  selectedId == null ? Colors.grey : CustomColors.kAccentColor,
            ),
            onPressed: selectedId == null
                ? null
                : () => Navigator.of(context).pop(
                      {"name": selectedName, "id": selectedId},
                    ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                child: SearchBar(
                  hint: "Buscar jugador",
                  onChanged: (newSearch) {
                    setState(() {
                      search = newSearch;
                    });
                  },
                ),
              ),
              Expanded(
                child: PlayersList(
                  search: search,
                  selectedId: selectedId,
                  select: selectPlayer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
