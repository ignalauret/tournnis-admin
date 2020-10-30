import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/constants.dart';

class ActionButton extends StatelessWidget {
  ActionButton(this.label, this.onTap);
  final String label;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          color: CustomColors.kAccentColor,
          borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
