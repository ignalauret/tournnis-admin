import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/create_match/create_match_screen.dart';
import 'package:tournnis_admin/screens/home/home_screen.dart';
import 'package:tournnis_admin/screens/matches/matches_screen.dart';
import 'package:tournnis_admin/screens/select_player/select_player_screen.dart';
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
      ],
      child: MaterialApp(
        title: 'Tournnis',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: CustomColors.kMainColor,
          accentColor: CustomColors.kAccentColor,
          fontFamily: "Montserrat",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        routes: {
          MatchesScreen.routeName: (context) => MatchesScreen(),
          CreateMatchScreen.routeName: (context) => CreateMatchScreen(),
          SelectPlayerScreen.routeName: (context) => SelectPlayerScreen(),
        },
      ),
    );
  }
}
