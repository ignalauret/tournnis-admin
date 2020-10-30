import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/matches/components/matches_list.dart';
import 'package:tournnis_admin/screens/matches/matches_screen.dart';
import 'package:tournnis_admin/screens/players/players_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tournnis"),
      ),
      backgroundColor: CustomColors.kMainColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            FlatButton(
              child: Text(
                "Ver Partidos",
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(MatchesScreen.routeName);
              },
            ),
            FlatButton(
              child: Text(
                "Ver Jugadores",
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(PlayersScreen.routeName);
              },
            ),
          ],
        ),
      ),
      // body: Consumer2<PlayersProvider, MatchesProvider>(
      //   builder: (context, playersData, matchesData, _) {
      //     return Column(
      //       children: [
      //         FlatButton(
      //           onPressed: () {
      //             playersData.newPlayerBirth = DateTime.now();
      //             playersData.newPlayerClub = "Las Delicias";
      //             playersData.newPlayerName = "Ignacio Lauret";
      //             playersData.newPlayerNationality = "Argentina";
      //             playersData.newPlayerOneHanded = false;
      //             playersData.newPlayerRightHanded = false;
      //             playersData.createPlayer().then((value) {
      //               if (value)
      //                 print("Succesfull creation");
      //               else
      //                 print("Error creating");
      //             });
      //           },
      //           child: Text("Crear Jugador"),
      //         ),
      //         FlatButton(
      //           onPressed: () async {
      //             final players = await playersData.players;
      //             print(players);
      //             pid1 = players[0].id;
      //             pid2 = players[1].id;
      //           },
      //           child: Text("Get jugadores"),
      //         ),
      //         FlatButton(
      //           onPressed: () {
      //             matchesData
      //                 .createMatch(
      //                   TournamentMatch(
      //                       pid1: pid1,
      //                       pid2: pid2,
      //                       result1: [6, 6],
      //                       result2: [2, 3],
      //                       date: DateTime.now(),
      //                       tid: "0",
      //                       isPlayOff: false,
      //                       category: 0,
      //                       playOffRound: null),
      //                 )
      //                 .then((value) => print(value ? "Successfull" : "Error"));
      //           },
      //           child: Text("Crear partido"),
      //         ),
      //         FlatButton(
      //           onPressed: () {
      //             print(matchesData.matches);
      //           },
      //           child: Text("Get partidos"),
      //         )
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
