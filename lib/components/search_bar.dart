import 'package:flutter/material.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class SearchBar extends StatelessWidget {
  SearchBar({this.hint, this.onChanged});

  final String hint;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: const TextStyle(
          color: CustomColors.kAccentColor,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: CustomStyles.kNormalStyle
              .copyWith(color: CustomColors.kAccentColor.withOpacity(0.5)),
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
          prefixIcon: const Icon(
            Icons.search,
            color: CustomColors.kAccentColor,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
