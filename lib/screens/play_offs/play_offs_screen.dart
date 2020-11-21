import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/components/menu_button.dart';
import 'package:tournnis_admin/screens/play_offs/components/play_off_draw.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class PlayOffsScreen extends StatefulWidget {
  static const routeName = "/play-offs";
  @override
  _PlayOffsScreenState createState() => _PlayOffsScreenState();
}

class _PlayOffsScreenState extends State<PlayOffsScreen> {
  @override
  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text(
          "PlayOffs",
          style: CustomStyles.kAppBarTitle,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity,),
            MenuButton(
              "Platino",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: {"tid": tid, "category": 0}),
            ),
            MenuButton(
              "Oro",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: {"tid": tid, "category": 1}),
            ),
            MenuButton(
              "Plata",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: {"tid": tid, "category": 2}),
            ),
            MenuButton(
              "Bronce",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: {"tid": tid, "category": 3}),
            ),
          ],
        ),
      ),
    );
  }
}
