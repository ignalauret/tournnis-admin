import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  SearchBar({this.hint, this.onChanged});

  final String hint;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 17,
          ),
          border: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
