import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/custom_styles.dart';

const kCategories = ["Platino", "Oro", "Plata", "Bronce", "Todas"];

class CategorySelector extends StatelessWidget {
  CategorySelector({this.select, this.selectedCat, this.options});

  CategorySelector.withAll({this.select, this.selectedCat})
      : options = [4, 0, 1, 2, 3];

  final int selectedCat;
  final Function(int) select;
  final List<int> options;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          ...options.map(
            (index) => _buildCategoryButton(kCategories[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String name, int id) {
    final selected = selectedCat == id;
    return Container(
      child: GestureDetector(
        onTap: () {
          select(id);
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            name,
            style: CustomStyles.kResultStyle.copyWith(
              color: selected
                  ? CustomColors.kSelectedItemColor
                  : CustomColors.kUnselectedItemColor,
            ),
          ),
        ),
      ),
    );
  }
}
