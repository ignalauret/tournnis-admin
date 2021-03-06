import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/custom_styles.dart';

class MenuButton extends StatelessWidget {
  MenuButton(this.label, this.onTap,
      {this.letterColor = CustomColors.kWhiteColor});

  final String label;
  final Function onTap;
  final Color letterColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.6,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CustomColors.kMainColor,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            label,
            style: CustomStyles.kResultStyle.copyWith(color: letterColor),
          ),
        ),
      ),
    );
  }
}
