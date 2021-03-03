import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/screens/create_elimination_draw/create_elimination_draw.dart';

import '../../components/menu_button.dart';
import '../../providers/play_offs_provider.dart';
import '../../screens/play_offs/components/play_off_draw.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class PlayOffsScreen extends StatefulWidget {
  static const routeName = "/play-offs";
  @override
  _PlayOffsScreenState createState() => _PlayOffsScreenState();
}

class _PlayOffsScreenState extends State<PlayOffsScreen> {
  @override
  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;
    final PlayOffsProvider playoffData = context.watch<PlayOffsProvider>();
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Playoffs",
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            MenuButton(
              "Platino",
              () {
                final poff = playoffData.getPlayOff(tid, 0);
                if (poff.hasStarted)
                  Navigator.of(context)
                      .pushNamed(PlayOffDraw.routeName, arguments: poff);
                else
                  Navigator.of(context).pushNamed(
                      CreateEliminationDraw.routeName,
                      arguments: tid);
              },
            ),
            MenuButton(
              "Oro",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: playoffData.getPlayOff(tid, 1)),
            ),
            MenuButton(
              "Plata",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: playoffData.getPlayOff(tid, 2)),
            ),
            MenuButton(
              "Bronce",
              () => Navigator.of(context).pushNamed(PlayOffDraw.routeName,
                  arguments: playoffData.getPlayOff(tid, 3)),
            ),
          ],
        ),
      ),
    );
  }
}
