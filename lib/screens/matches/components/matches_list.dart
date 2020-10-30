import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';

class MatchesList extends StatelessWidget {
  MatchesList(this.selectedCategory);
  final int selectedCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TournamentMatch>>(
      future: context.watch<MatchesProvider>().matches,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TournamentMatch> filteredList = snapshot.data
              .where((match) =>
                  selectedCategory == 4 || match.category == selectedCategory)
              .toList();
          return ListView.builder(
            itemBuilder: (context, index) {
              return MatchCard(filteredList[index]);
            },
            itemCount: filteredList.length,
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
