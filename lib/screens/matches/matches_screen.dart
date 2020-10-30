import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/screens/create_match/create_match_screen.dart';
import 'package:tournnis_admin/screens/matches/components/matches_list.dart';
import 'package:tournnis_admin/utils/colors.dart';

class MatchesScreen extends StatefulWidget {
  static const routeName = "/matches";

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int selectedCategory = 4;

  void selectCategory(int cat) {
    setState(() {
      selectedCategory = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text("Partidos"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(CreateMatchScreen.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            CategorySelector.withAll(
              selectedCat: selectedCategory,
              select: selectCategory,
            ),
            Expanded(child: MatchesList(selectedCategory)),
          ],
        ),
      ),
    );
  }
}
