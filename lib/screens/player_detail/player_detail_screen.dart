import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/match_card.dart';
import '../../models/player.dart';
import '../../models/tournament_match.dart';
import '../../providers/matches_provider.dart';
import '../../providers/players_provider.dart';
import '../../screens/create_player/create_player_screen.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class PlayerDetailScreen extends StatelessWidget {
  static const routeName = "/player-detail";
  @override
  Widget build(BuildContext context) {
    final String pid = ModalRoute.of(context).settings.arguments;
    final player = context.select<PlayersProvider, Player>(
      (data) => data.getPlayerById(pid),
    );
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
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: context
                .select<MatchesProvider, List<TournamentMatch>>(
                    (data) => data.getPlayerMatches(pid))
                .map((match) => MatchCard(match))
                .toList(),
          ),
        ),
      ),
    );
  }
}
