import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';

class CustomStyles {
  static const kAppBarTitle = TextStyle(
    color: CustomColors.kAccentColor,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const kTitleStyle = TextStyle(
    color: CustomColors.kAccentColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const kNormalStyle = TextStyle(
    color: CustomColors.kMainColor,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  static const kPlayerNameStyle = TextStyle(
    color: CustomColors.kBackgroundColor,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static final kLighterPlayerNameStyle = TextStyle(
    color: CustomColors.kBackgroundColor.withOpacity(0.7),
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const kResultStyle = TextStyle(
    color: CustomColors.kBackgroundColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static final kLighterResultStyle = TextStyle(
    color: CustomColors.kBackgroundColor.withOpacity(0.7),
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const kCategoryStyle = TextStyle(
    color: CustomColors.kAccentColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static final kSubtitleStyle = TextStyle(
    color: CustomColors.kAccentColor.withOpacity(0.7),
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
}
