import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_tab_bar.dart';
import 'package:tournnis_admin/components/category_tab_bar.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

import 'components/matches_list.dart';

class MatchesScreen extends StatelessWidget {
  static const routeName = "/matches";

  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Partidos",
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              CategoryTabBar.withAll(),
              Expanded(
                child: TabBarView(
                  children: List.generate(
                    5,
                    (index) => MatchesList(
                      index == 0 ? 4 : index - 1,
                      tid,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
