import 'package:flutter/material.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/screens/select_player/components/players_list.dart';
import 'package:tournnis_admin/utils/colors.dart';

class PlayersScreen extends StatelessWidget {
  static const routeName = "/players";
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
          padding: const EdgeInsets.all(20),
          child: PlayersList(),
        ),
      ),
    );
  }
}
