import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({@required this.imagePath, @required this.diameter});
  final String imagePath;
  final double diameter;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imagePath == null || imagePath.contains("ignacio_lauret")
              ? AssetImage("assets/img/icon.png")
              : NetworkImage(imagePath),
        ),
      ),
    );
  }
}
