import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

const kCategoryNames = ["Todas", "Platino", "Oro", "Plata", "Bronce"];

class CategoryTabBar extends StatelessWidget {
  CategoryTabBar({this.onSelect, this.options = const [0, 1, 2, 3]});
  CategoryTabBar.withAll({this.onSelect}) : options = [0, 1, 2, 3, 4];

  final Function(int) onSelect;
  final List<int> options;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: List.generate(
        options.length,
        (index) => FittedBox(
          fit: BoxFit.scaleDown,
          child: Tab(
            text: kCategoryNames[
                options.length == 5 ? options[index] : options[index] + 1],
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
