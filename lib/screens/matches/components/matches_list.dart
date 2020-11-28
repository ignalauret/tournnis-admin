import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/match_card.dart';
import '../../../models/tournament_match.dart';
import '../../../providers/matches_provider.dart';

class MatchesList extends StatelessWidget {
  MatchesList(this.selectedCategory, this.tid);
  final int selectedCategory;
  final String tid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TournamentMatch>>(
      future: context.watch<MatchesProvider>().matches,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<TournamentMatch> filteredList = snapshot.data
              .where(
                (match) =>
                    match.tid == tid &&
                    match.date != null &&
                    (selectedCategory == 4 ||
                        match.category == selectedCategory),
              )
              .toList();
          filteredList.sort((m1, m2) => m2.date.compareTo(m1.date));
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
