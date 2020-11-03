import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/providers/tournaments_provider.dart';
import 'package:tournnis_admin/screens/groups_stage/groups_stage_screen.dart';
import 'package:tournnis_admin/screens/matches/matches_screen.dart';
import 'package:tournnis_admin/screens/players/players_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;
    final tName = context.select<TournamentsProvider, String>(
      (data) => data.getTournamentName(tid),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(tName),
      ),
      backgroundColor: CustomColors.kMainColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                "Ver Partidos",
                style: CustomStyles.kResultStyle.copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MatchesScreen.routeName, arguments: tid);
              },
            ),
            FlatButton(
              child: Text(
                "Ver Jugadores",
                style: CustomStyles.kResultStyle.copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(PlayersScreen.routeName, arguments: tid);
              },
            ),
            FlatButton(
              child: Text(
                "Ver Grupos",
                style: CustomStyles.kResultStyle.copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(GroupStageScreen.routeName, arguments: tid);
              },
            ),
          ],
        ),
      ),
    );
  }
}
