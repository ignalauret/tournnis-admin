import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

const kCategoryNames = ["Todas", "Platino", "Oro", "Plata", "Bronce"];

class CategoryTabBar extends StatelessWidget {
  CategoryTabBar({this.onSelect}) : options = 4;
  CategoryTabBar.withAll({this.onSelect}) : options = 5;

  final Function(int) onSelect;
  final int options;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: List.generate(
        options,
        (index) => FittedBox(
          fit: BoxFit.scaleDown,
          child: Tab(
            text: kCategoryNames[options == 4 ? index + 1 : index],
          ),
        ),
      ),
      onTap: onSelect,
      labelPadding: const EdgeInsets.all(0),
      unselectedLabelColor: CustomColors.kUnselectedItemColor,
      labelStyle: CustomStyles.kResultStyle,
      labelColor: CustomColors.kSelectedItemColor,
    );
  }
}
