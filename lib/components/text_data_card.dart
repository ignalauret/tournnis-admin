import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import '../utils/constants.dart';
import '../utils/custom_styles.dart';

class TextDataCard extends StatelessWidget {
  TextDataCard({
    @required this.title,
    @required this.data,
    @required this.size,
    this.onTap,
  });

  final String title;
  final String data;
  final Size size;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 21,
          width: size.width * 0.8,
          child: Text(
            title,
            style: CustomStyles.kResultStyle.copyWith(
              color: CustomColors.kAccentColor.withOpacity(0.5),
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            width: size.width * 0.8,
            padding: const EdgeInsets.only(
              left: 20,
            ),
            decoration: BoxDecoration(
              color: CustomColors.kAccentColor,
              borderRadius: BorderRadius.circular(Constants.kCardBorderRadius),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  data,
                  style: CustomStyles.kResultStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
