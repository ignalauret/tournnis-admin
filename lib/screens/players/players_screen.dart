import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_tab_bar.dart';

import 'package:provider/provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import '../../screens/create_player/create_player_screen.dart';
import '../../screens/players/components/ranking.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

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
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Jugadores",
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
              Icons.add,
              color: CustomColors.kAccentColor,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CreatePlayerScreen.routeName);
            },
          ),
          // Dev button, for cleaning db
          // IconButton(
          //   icon: Icon(
          //     Icons.cancel,
          //     color: CustomColors.kAccentColor,
          //   ),
          //   onPressed: () {
          //     context.read<PlayersProvider>().restartPoints();
          //   },
          // ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Container(
            child: Column(
              children: [
                CategoryTabBar(),
                Expanded(
                  child: TabBarView(
                    children: List.generate(
                      4,
                      (index) => Ranking(index),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
