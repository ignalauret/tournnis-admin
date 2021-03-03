import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/providers/auth.dart';
import 'package:tournnis_admin/providers/groups_provider.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/notices_provider.dart';
import 'package:tournnis_admin/providers/play_offs_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/providers/tournaments_provider.dart';
import 'package:tournnis_admin/screens/create_elimination_draw/create_elimination_draw.dart';
import 'package:tournnis_admin/screens/create_group/create_group.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/screens/create_tournament/create_tournament_screen.dart';
import 'package:tournnis_admin/screens/edit_group/edit_group_screen.dart';
import 'package:tournnis_admin/screens/edit_play_off/edit_play_off_screen.dart';
import 'package:tournnis_admin/screens/group_matches/group_matches_screen.dart';
import 'package:tournnis_admin/screens/groups_stage/groups_stage_screen.dart';
import 'package:tournnis_admin/screens/home/home_screen.dart';
import 'package:tournnis_admin/screens/login/login_screen.dart';
import 'package:tournnis_admin/screens/login/splash_screen.dart';
import 'package:tournnis_admin/screens/match_options/match_options_screen.dart';
import 'package:tournnis_admin/screens/matches/matches_screen.dart';
import 'package:tournnis_admin/screens/notices/notices_screen.dart';
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
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, PlayersProvider>(
          create: (context) => PlayersProvider(null),
          update: (context, authData, prev) => PlayersProvider(authData.token),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<Auth, MatchesProvider>(
          create: (context) => MatchesProvider(null),
          update: (context, authData, prev) => MatchesProvider(authData.token),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<Auth, GroupsProvider>(
          create: (context) => GroupsProvider(null),
          update: (context, authData, prev) => GroupsProvider(authData.token),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<Auth, TournamentsProvider>(
          create: (context) => TournamentsProvider(null),
          update: (context, authData, prev) =>
              TournamentsProvider(authData.token),
        ),
        ChangeNotifierProxyProvider<Auth, PlayOffsProvider>(
          create: (context) => PlayOffsProvider(null),
          update: (context, authData, prev) => PlayOffsProvider(authData.token),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<Auth, NoticesProvider>(
          create: (context) => NoticesProvider(null),
          update: (context, authData, prev) => NoticesProvider(authData.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
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
          home: authData.isAuth
              ? SelectTournamentScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogIn(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen(),
                ),
          routes: {
            HomeScreen.routeName: (context) => HomeScreen(),
            CreateTournamentScreen.routeName: (context) =>
                CreateTournamentScreen(),
            // Matches
            MatchesScreen.routeName: (context) => MatchesScreen(),
            MatchOptionsScreen.routeName: (context) => MatchOptionsScreen(),
            // Groups
            GroupStageScreen.routeName: (context) => GroupStageScreen(),
            CreateGroup.routeName: (context) => CreateGroup(),
            EditGroupScreen.routeName: (context) => EditGroupScreen(),
            GroupMatchesScreen.routeName: (context) => GroupMatchesScreen(),
            // Players
            SelectPlayerScreen.routeName: (context) => SelectPlayerScreen(),
            PlayersScreen.routeName: (context) => PlayersScreen(),
            CreatePlayerScreen.routeName: (context) => CreatePlayerScreen(),
            PlayerDetailScreen.routeName: (context) => PlayerDetailScreen(),
            // Play Offs
            PlayOffsScreen.routeName: (context) => PlayOffsScreen(),
            PlayOffDraw.routeName: (context) => PlayOffDraw(),
            EditPlayOffScreen.routeName: (context) => EditPlayOffScreen(),
            CreateEliminationDraw.routeName: (context) =>
                CreateEliminationDraw(),
            // Notices
            NoticesScreen.routeName: (context) => NoticesScreen(),
          },
        ),
      ),
    );
  }
}
