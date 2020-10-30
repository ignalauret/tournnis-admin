import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';

class MatchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TournamentMatch>>(
      future: context.watch<MatchesProvider>().matches,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return MatchCard(snapshot.data[index]);
            },
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
