import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class MenuButton extends StatelessWidget {
  MenuButton(this.label, this.onTap, {this.letterColor = CustomColors.kMainColor});
  final String label;
  final Function onTap;
  final Color letterColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 180,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            label,
            style:
                CustomStyles.kResultStyle.copyWith(color: letterColor),
          ),
        ),
      ),
    );
  }
}
