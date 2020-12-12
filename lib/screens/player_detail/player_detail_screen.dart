import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/components/profile_picture.dart';

import '../../components/match_card.dart';
import '../../models/player.dart';
import '../../providers/matches_provider.dart';
import '../../providers/players_provider.dart';
import '../../screens/create_player/create_player_screen.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class PlayerDetailScreen extends StatefulWidget {
  static const routeName = "/player-detail";
  @override
  _PlayerDetailScreenState createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final String pid = args["pid"];
    final String tid = args["tid"];
    final player = context.select<PlayersProvider, Player>(
      (data) => data.getPlayerById(pid),
    );
    final playerRecord = context.select<MatchesProvider, Map<String, int>>(
        (data) => data.getPlayerResultsFromTournament(
            player.id, tid, selectedCategory));
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            context.select<PlayersProvider, String>(
              (data) => data.getPlayerName(pid),
            ),
            style: CustomStyles.kAppBarTitle,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                CreatePlayerScreen.routeName,
                arguments: player,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: size.height * 0.5,
              width: size.width,
              padding: const EdgeInsets.all(10),
              color: Colors.black26,
              child: Column(
                children: [
                  _buildImageSection(
                      size: size,
                      imageUrl: player.imageUrl,
                      name: player.name,
                      age: player.age),
                  Spacer(),
                  _buildPlayerInfoSection(
                    hand: player.hand,
                    backhand: player.backhandType,
                    racket: player.racket == null || player.racket.isEmpty ? "-" : player.racket,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CategorySelector(
                options: [0, 1, 2, 3],
                selectedCat: selectedCategory,
                select: (cat) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
              ),
            ),
            FutureBuilder<int>(
              future: context
                  .watch<PlayersProvider>()
                  .getPlayerRankingFromTournament(
                      context, player.id, tid, selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: snapshot.data == 0
                        ? Container(
                            height: 150,
                            child: Center(
                              child: Text(
                                "No jugó esta categoría",
                                style: CustomStyles.kSubtitleStyle,
                              ),
                            ),
                          )
                        : _buildStatsSection(
                            snapshot.data.toString(),
                            player
                                .getTournamentPointsOfCategory(
                                    tid, selectedCategory)
                                .toString(),
                            "0",
                            "${playerRecord["wins"]}-${playerRecord["loses"] + playerRecord["superTiebreaks"]}",
                          ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            ...context
                .watch<MatchesProvider>()
                .getPlayerMatches(player.id, tid, selectedCategory)
                .map((match) => MatchCard(match)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(
      {Size size, String imageUrl, String name, int age}) {
    return Container(
      child: Column(
        children: [
          ProfilePicture(imagePath: imageUrl, diameter: size.height * 0.3),
          SizedBox(
            height: 15,
          ),
          Text(
            name,
            style: CustomStyles.kAppBarTitle,
          ),
          Text(
            "$age años",
            style: CustomStyles.kResultStyle
                .copyWith(color: CustomColors.kAccentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoSection(
      {String hand, String backhand, String racket}) {
    return Container(
      child: Row(
        children: [
          _buildPlayerInfo("Mano hábil", hand),
          _buildPlayerInfo("Revés", backhand),
          _buildPlayerInfo("Raqueta", racket),
        ],
      ),
    );
  }

  Expanded _buildPlayerInfo(String label, String value) {
    return Expanded(
      child: Container(
        height: 40,
        child: Column(
          children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: CustomStyles.kSubtitleStyle,
                )),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: CustomStyles.kNormalStyle,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
      String ranking, String points, String titles, String record) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat("Ranking", ranking),
              _buildStat("Puntos", points),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat("Títulos", titles),
              _buildStat("Récord", record),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              )),
          Text(
            label,
            style: CustomStyles.kResultStyle
                .copyWith(color: CustomColors.kAccentColor),
          ),
        ],
      ),
    );
  }
}
