import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/custom_styles.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.controller,
    this.label,
    this.hint,
    this.letterColor = CustomColors.kMainColor,
    this.hintColor = Colors.black54,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final Color letterColor;
  final Color hintColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: CustomStyles.kNormalStyle.copyWith(color: letterColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: CustomStyles.kResultStyle
            .copyWith(color: CustomColors.kAccentColor),
        hintText: hint,
        hintStyle: CustomStyles.kNormalStyle.copyWith(color: hintColor),
        alignLabelWithHint: true,
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.kAccentColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.kAccentColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.kAccentColor,
          ),
        ),
      ),
    );
  }
}
