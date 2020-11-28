import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/custom_styles.dart';
import '../../components/menu_button.dart';
import '../../models/tournament.dart';
import '../../providers/tournaments_provider.dart';
import '../../screens/home/home_screen.dart';
import '../../utils/colors.dart';

class SelectTournamentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text(
          "Tournnis",
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Tournament>>(
          future: context.watch<TournamentsProvider>().tournaments,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: snapshot.data
                      .map((tournament) => MenuButton(
                            tournament.name,
                            () => Navigator.of(context).pushNamed(
                                HomeScreen.routeName,
                                arguments: tournament.id),
                          ))
                      .toList(),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
