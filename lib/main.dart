import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/providers/tournaments_provider.dart';
import 'package:tournnis_admin/screens/create_group/create_group.dart';
import 'package:tournnis_admin/screens/create_match/create_match_screen.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/screens/edit_group/edit_group_screen.dart';
import 'package:tournnis_admin/screens/group_matches/group_matches_screen.dart';
import 'package:tournnis_admin/screens/groups_stage/groups_stage_screen.dart';
import 'package:tournnis_admin/screens/home/home_screen.dart';
import 'package:tournnis_admin/screens/match_options/match_options_screen.dart';
import 'package:tournnis_admin/screens/matches/matches_screen.dart';
import 'package:tournnis_admin/screens/play_offs/components/play_off_draw.dart';
import 'package:tournnis_admin/screens/play_offs/play_offs_screen.dart';
import 'package:tournnis_admin/screens/player_detail/player_detail_screen.dart';
import 'package:tournnis_admin/screens/players/players_screen.dart';
import 'package:tournnis_admin/screens/select_player/select_player_screen.dart';
import 'package:tournnis_admin/screens/select_tournament/select_tournament_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlayersProvider>(
          create: (context) => PlayersProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<MatchesProvider>(
          create: (context) => MatchesProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<GroupsProvider>(
          create: (context) => GroupsProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider<TournamentsProvider>(
          create: (context) => TournamentsProvider(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Tournnis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: CustomColors.kMainColor,
          accentColor: CustomColors.kAccentColor,
          colorScheme: ColorScheme.light(
              primary: CustomColors.kMainColor,
              secondary: CustomColors.kAccentColor),
          fontFamily: "Montserrat",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SelectTournamentScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          MatchesScreen.routeName: (context) => MatchesScreen(),
          MatchOptionsScreen.routeName: (context) => MatchOptionsScreen(),
          CreateMatchScreen.routeName: (context) => CreateMatchScreen(),
          GroupStageScreen.routeName: (context) => GroupStageScreen(),
          CreateGroup.routeName: (context) => CreateGroup(),
          EditGroupScreen.routeName: (context) => EditGroupScreen(),
          GroupMatchesScreen.routeName: (context) => GroupMatchesScreen(),
          SelectPlayerScreen.routeName: (context) => SelectPlayerScreen(),
          PlayersScreen.routeName: (context) => PlayersScreen(),
          CreatePlayerScreen.routeName: (context) => CreatePlayerScreen(),
          PlayerDetailScreen.routeName: (context) => PlayerDetailScreen(),
          PlayOffsScreen.routeName: (context) => PlayOffsScreen(),
          PlayOffDraw.routeName: (context) => PlayOffDraw(),
        },
      ),
    );
  }
}
