import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';

class CustomStyles {
  static const kTitleStyle = TextStyle(
    color: CustomColors.kAccentColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const kNormalStyle = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const kPlayerNameStyle = TextStyle(
    color: CustomColors.kMainColor,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const kResultStyle = TextStyle(
    color: CustomColors.kMainColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const kCategoryStyle = TextStyle(
    color: CustomColors.kAccentColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const kSubtitleStyle = TextStyle(
    color: Colors.white70,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
}
