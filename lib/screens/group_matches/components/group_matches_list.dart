import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/match_card.dart';
import 'package:tournnis_admin/models/group_zone.dart';
import 'package:tournnis_admin/models/tournament_match.dart';
import 'package:tournnis_admin/providers/matches_provider.dart';

class GroupMatchesList extends StatelessWidget {
  GroupMatchesList(this.group);
  final GroupZone group;

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchesProvider>(
      builder: (context, matchesData, _) {
        final List<TournamentMatch> matches =
            matchesData.getMatchesById(group.matchesIds);
        return ListView.builder(
          itemBuilder: (context, index) {
            return MatchCard(matches[index]);
          },
          itemCount: matches.length,
        );
      },
    );
  }
}
