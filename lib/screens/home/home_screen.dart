import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/screens/notices/notices_screen.dart';

import '../../components/menu_button.dart';
import '../../providers/tournaments_provider.dart';
import '../../screens/groups_stage/groups_stage_screen.dart';
import '../../screens/matches/matches_screen.dart';
import '../../screens/play_offs/play_offs_screen.dart';
import '../../screens/players/players_screen.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

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
        title: Text(
          tName,
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      backgroundColor: CustomColors.kMainColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              "Partidos",
              () => Navigator.of(context)
                  .pushNamed(MatchesScreen.routeName, arguments: tid),
            ),
            MenuButton(
              "Jugadores",
              () => Navigator.of(context)
                  .pushNamed(PlayersScreen.routeName, arguments: tid),
            ),
            MenuButton(
              "Grupos",
              () => Navigator.of(context)
                  .pushNamed(GroupStageScreen.routeName, arguments: tid),
            ),
            MenuButton(
              "Play Offs",
              () => Navigator.of(context)
                  .pushNamed(PlayOffsScreen.routeName, arguments: tid),
            ),
            MenuButton(
              "Noticias",
              () => Navigator.of(context)
                  .pushNamed(NoticesScreen.routeName, arguments: tid),
            ),
          ],
        ),
      ),
    );
  }
}
