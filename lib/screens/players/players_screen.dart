import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/screens/select_player/components/players_list.dart';
import 'package:tournnis_admin/utils/colors.dart';

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
              ),
              Expanded(
                child: PlayersList(
                  showPoints: true,
                  selectedCategory: selectedCategory,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
