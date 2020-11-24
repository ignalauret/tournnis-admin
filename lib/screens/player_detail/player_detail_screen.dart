import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/players_provider.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

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
          child: Column(
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
