import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

const Categories = ["Platino", "Oro", "Plata", "Bronce", "Todas"];

class CategorySelector extends StatelessWidget {
  CategorySelector({this.select, this.selectedCat}) : options = [0, 1, 2, 3];
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
            (index) => _buildCategoryButton(Categories[index], index),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String name, int id) {
    final selected = selectedCat == id;
    return Container(
      child: InkWell(
        onTap: () {
          select(id);
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            name,
            style: CustomStyles.kResultStyle.copyWith(
              color: selected ? CustomColors.kAccentColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
