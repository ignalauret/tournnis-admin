import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tournament_match.dart';
import '../providers/matches_provider.dart';
import '../providers/players_provider.dart';
import '../screens/match_options/match_options_screen.dart';
import '../screens/matches/components/match_result_dialog.dart';
import '../utils/time_methods.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/custom_styles.dart';

class MatchCard extends StatelessWidget {
  MatchCard(this.match);
  final TournamentMatch match;

  Future<void> _setMatchDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      helpText: "Elegir fecha del partido",
      confirmText: "Confirmar",
      cancelText: "Cancelar",
    );
    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        confirmText: "Confirmar",
        cancelText: "Cancelar",
        helpText: "Elegir hora del partido",
      );
      if (pickedTime != null) {
        context.read<MatchesProvider>().addDate(
              match,
              DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                  pickedTime.hour, pickedTime.minute),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<PlayersProvider>(
      builder: (context, playersData, _) => Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            _buildHeader(
                match.date, match.categoryName, size, match.isPredicted),
            GestureDetector(
              onTap:
                  match.isPredicted || match.pid1 == null || match.pid2 == null
                      ? null
                      : () => Navigator.of(context).pushNamed(
                            MatchOptionsScreen.routeName,
                            arguments: match.id,
                          ),
              child: Container(
                height: 60,
                width: size.width * 0.85,
                decoration: BoxDecoration(
                  color: CustomColors.kMainColor,
                  borderRadius:
                      BorderRadius.circular(Constants.kCardBorderRadius),
                ),
                child: Row(
                  children: [
                    _buildRankingsContainer(
                      playersData.getPlayerGlobalRanking(
                          match.pid1, match.category),
                      playersData.getPlayerGlobalRanking(
                          match.pid2, match.category),
                    ),
                    Expanded(
                      child: match.hasEnded ||
                              match.pid1 == null ||
                              match.pid2 == null ||
                              match.isPredicted
                          ? Column(
                              children: [
                                Expanded(
                                  child: _buildPlayerRow(
                                    playersData.getPlayerName(match.pid1),
                                    match.isWo != 0 ? null : match.result1,
                                    match.isPredicted
                                        ? false
                                        : !match.isSecondWinner,
                                    match.isWo == 2,
                                    match.isWo == 3,
                                  ),
                                ),
                                Expanded(
                                  child: _buildPlayerRow(
                                    playersData.getPlayerName(match.pid2),
                                    match.isWo != 0 ? null : match.result2,
                                    match.isPredicted
                                        ? false
                                        : !match.isFirstWinner,
                                    match.isWo == 1,
                                    match.isWo == 3,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: _buildPlayerRow(
                                          playersData.getPlayerName(match.pid1),
                                          match.result1,
                                          !match.isSecondWinner,
                                          match.isWo == 2,
                                          match.isWo == 3,
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildPlayerRow(
                                          playersData.getPlayerName(match.pid2),
                                          match.result2,
                                          !match.isFirstWinner,
                                          match.isWo == 1,
                                          match.isWo == 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildMatchAction(context, match),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildHeader(
      DateTime date, String category, Size size, bool isPredicted) {
    return Container(
      height: 25,
      width: size.width * 0.85,
      child: Row(
        children: [
          SizedBox(
            width: 35,
          ),
          Text(
            isPredicted
                ? "Predicción"
                : date == null
                    ? "Por organizar"
                    : TimeMethods.parseDate(date),
            style: CustomStyles.kResultStyle.copyWith(
              color: CustomColors.kAccentColor,
              fontStyle: isPredicted ? FontStyle.italic : null,
              letterSpacing: -0.5,
            ),
          ),
          Spacer(),
          Text(
            category,
            style: CustomStyles.kCategoryStyle,
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Container _buildRankingsContainer(
      Future<int> ranking1, Future<int> ranking2) {
    return Container(
      height: 60,
      width: 30,
      decoration: BoxDecoration(
        color: CustomColors.kAccentColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constants.kCardBorderRadius),
          bottomLeft: Radius.circular(Constants.kCardBorderRadius),
        ),
      ),
      child: Column(
        children: [
          FutureBuilder<int>(
            future: ranking1,
            builder: (context, snapshot) {
              if (snapshot.hasData) return _buildRanking(snapshot.data);
              return Container();
            },
          ),
          FutureBuilder<int>(
            future: ranking2,
            builder: (context, snapshot) {
              if (snapshot.hasData) return _buildRanking(snapshot.data);
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRanking(int ranking) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      child: Text(
        ranking == 0 ? "-" : ranking.toString(),
        style:
            CustomStyles.kResultStyle.copyWith(color: CustomColors.kWhiteColor),
      ),
    );
  }

  Row _buildPlayerRow(
      String name, List<int> score, bool isWinner, bool wo, bool isDoubleWo) {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              style: isWinner
                  ? CustomStyles.kPlayerNameStyle
                  : CustomStyles.kLighterPlayerNameStyle,
            ),
          ),
        ),
        if (wo)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "W.O.",
              style: CustomStyles.kResultStyle,
            ),
          ),
        if (isDoubleWo)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Penaliz.",
              style: CustomStyles.kResultStyle,
            ),
          ),
        if (score != null && !wo && !isDoubleWo)
          ...score.map(
            (score) => Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              child: Text(
                score.toString(),
                style: isWinner
                    ? CustomStyles.kResultStyle
                    : CustomStyles.kLighterResultStyle,
              ),
            ),
          ),
      ],
    );
  }

  Container _buildMatchAction(BuildContext context, TournamentMatch match) {
    return Container(
      width: 60,
      height: 60,
      child: match.date == null
          ? IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: CustomColors.kAccentColor,
                size: 35,
              ),
              onPressed: () => _setMatchDate(context),
            )
          : IconButton(
              icon: Icon(
                Icons.add,
                color: CustomColors.kAccentColor,
                size: 35,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => MatchResultDialog(match),
                );
              },
            ),
    );
  }
}
