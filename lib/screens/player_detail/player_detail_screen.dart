import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/category_tab_bar.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';
import 'package:tournnis_admin/providers/tournaments_provider.dart';
import 'package:tournnis_admin/screens/create_player/create_player_screen.dart';
import 'package:tournnis_admin/screens/player_detail/components/player_info_section.dart';

import '../../models/player.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';
import 'components/player_tournament_stats_section.dart';

class PlayerDetailScreen extends StatefulWidget {
  static const routeName = "/player-detail";
  @override
  _PlayerDetailScreenState createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final Player player = args["player"];

    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        elevation: 0,
        title: Container(
          child: Row(
            children: [
              Spacer(),
              Text(
                "PERFIL",
                style: CustomStyles.kAppBarTitle,
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
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
              Icons.edit,
              color: CustomColors.kAccentColor,
            ),
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
        child: DefaultTabController(
          length: 4,
          child: ListView(
            children: [
              PlayerInfoSection(player),
              CategoryTabBar(
                onSelect: (val) {
                  setState(() {
                    selectedCategory = val;
                  });
                },
              ),
              PlayerTournamentStatsSection(player, selectedCategory),
              _buildPlayerMatches(player),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder _buildPlayerMatches(Player player) {
    final List<TournamentMatch> matches = context
        .watch<MatchesProvider>()
        .getMatchesOfPlayerOnCategory(player.id, selectedCategory);
    return FutureBuilder<List<String>>(
        future: context.watch<TournamentsProvider>().tids,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: snapshot.data
                  .map((tid) => TournamentMatchList(
                        tid,
                        matches.where((match) => match.tid == tid).toList(),
                      ))
                  .toList(),
            );
          } else {
            return Container(
              height: 150,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class TournamentMatchList extends StatelessWidget {
  TournamentMatchList(this.tid, this.matches);
  final String tid;
  final List<TournamentMatch> matches;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: matches.isEmpty
          ? null
          : Column(
              children: [
                SizedBox(height: 5),
                Text(
                  context.select<TournamentsProvider, String>(
                    (data) => data.getTournamentName(tid),
                  ),
                  style: CustomStyles.kTitleStyle,
                ),
                SizedBox(height: 5),
                ...matches.map((match) => MatchCard(match)).toList(),
              ],
            ),
    );
  }
}
