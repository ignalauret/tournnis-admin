import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/screens/players/components/ranking.dart';
import 'package:tournnis_admin/screens/select_player/components/players_list.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class PlayersScreen extends StatefulWidget {
  static const routeName = "/players";

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  int selectedCategory = 0;

  void selectCategory(int cat) {
    setState(() {
      selectedCategory = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text("Jugadores"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(CreatePlayerScreen.routeName);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CategorySelector(
                selectedCat: selectedCategory,
                select: selectCategory,
                options: [0,1,2,3],
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 20,
                      width: 35,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nombre",
                          style: CustomStyles.kSubtitleStyle,
                        ),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "W",
                        style: CustomStyles.kSubtitleStyle,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "3S",
                        style: CustomStyles.kSubtitleStyle,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "L",
                        style: CustomStyles.kSubtitleStyle,
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 20,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 5),
                      child: Text(
                        "PTS",
                        style: CustomStyles.kSubtitleStyle,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Ranking(tid, selectedCategory),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
