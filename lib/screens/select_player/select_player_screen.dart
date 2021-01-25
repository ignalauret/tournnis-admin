import 'package:flutter/material.dart';

import '../../components/search_bar.dart';
import '../../models/player.dart';
import '../../screens/create_player/create_player_screen.dart';
import '../../screens/select_player/components/players_list.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Seleccionar jugador",
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: size.width * 0.7,
                      alignment: Alignment.center,
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
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(CreatePlayerScreen.routeName);
                        },
                        child: Container(
                          child: Text(
                            "Agregar",
                            style: CustomStyles.kResultStyle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
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
