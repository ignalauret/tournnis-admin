import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/models/tournament.dart';
import 'package:tournnis_admin/providers/tournaments_provider.dart';
import 'package:tournnis_admin/screens/home/home_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class SelectTournamentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text("Tournnis"),
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
                      .map(
                        (tournament) => FlatButton(
                          child: Text(
                            tournament.name,
                            style: CustomStyles.kResultStyle.copyWith(
                              color: CustomColors.kWhiteColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                HomeScreen.routeName,
                                arguments: tournament.id);
                          },
                        ),
                      )
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
