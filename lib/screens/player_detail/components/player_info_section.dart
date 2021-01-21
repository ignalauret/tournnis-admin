import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/profile_picture.dart';
import 'package:tournnis_admin/models/player.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class PlayerInfoSection extends StatelessWidget {
  PlayerInfoSection(this.player);
  final Player player;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width,
      padding: const EdgeInsets.all(10),
      color: CustomColors.kAppBarColor,
      child: Column(
        children: [
          _buildImageSection(
              size: size,
              imageUrl: player.imageUrl,
              name: player.name,
              age: player.age),
          Spacer(),
          _buildPlayerInfoSection(
            hand: player.hand,
            backhand: player.backhandType,
            racket: player.racket == null || player.racket.isEmpty
                ? "-"
                : player.racket,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
      {Size size, String imageUrl, String name, int age}) {
    return Container(
      child: Column(
        children: [
          ProfilePicture(imagePath: imageUrl, diameter: size.height * 0.3),
          SizedBox(height: 15),
          Text(
            name,
            style: CustomStyles.kAppBarTitle,
          ),
          Text(
            "$age años",
            style: CustomStyles.kResultStyle
                .copyWith(color: CustomColors.kUnselectedItemColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoSection(
      {String hand, String backhand, String racket}) {
    return Container(
      child: Row(
        children: [
          _buildPlayerInfo("Mano hábil", hand),
          _buildPlayerInfo("Revés", backhand),
          _buildPlayerInfo("Raqueta", racket),
        ],
      ),
    );
  }

  Expanded _buildPlayerInfo(String label, String value) {
    return Expanded(
      child: Container(
        height: 40,
        child: Column(
          children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: CustomStyles.kSubtitleStyle
                      .copyWith(color: CustomColors.kUnselectedItemColor),
                )),
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: CustomStyles.kResultStyle
                      .copyWith(color: CustomColors.kSelectedItemColor),
                )),
          ],
        ),
      ),
    );
  }
}
