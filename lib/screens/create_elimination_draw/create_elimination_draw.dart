import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournnis_admin/components/action_button.dart';
import 'package:tournnis_admin/components/text_data_card.dart';
import 'package:tournnis_admin/providers/play_offs_provider.dart';
import 'package:tournnis_admin/screens/select_player/select_player_screen.dart';
import 'package:tournnis_admin/utils/colors.dart';
import 'package:tournnis_admin/utils/custom_styles.dart';

class CreateEliminationDraw extends StatefulWidget {
  static const routeName = "/create-elimination-draw";
  @override
  _CreateEliminationDrawState createState() => _CreateEliminationDrawState();
}

class _CreateEliminationDrawState extends State<CreateEliminationDraw> {
  String tid;
  int selectedCategory = 0;
  int players = 32;
  List<String> pids = List.generate(32, (index) => null);
  List<String> names = List.generate(32, (index) => null);

  @override
  void didChangeDependencies() {
    tid = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  bool get canStart {
    for (int i = 0; i < players ~/ 2; i++) {
      if (pids[2 * i] == null && pids[2 * i + 1] == null) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Nueva Llave",
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildPlayersTitle(),
                      ...List.generate(names.length * 2, (index) => index)
                          .map(
                            (i) => i % 2 == 1
                                ? SizedBox(height: (i - 1) % 4 == 0 ? 5 : 35)
                                : _buildPlayerSelector(size, i ~/ 2),
                          )
                          .toList()
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ActionButton(
                "Crear Llave",
                () {
                  context
                      .read<PlayOffsProvider>()
                      .createPlayOffFromPlayerList(
                          context, tid, selectedCategory, pids)
                      .then(
                        (value) => Navigator.of(context).pop(),
                      );
                },
                enabled: canStart,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildPlayersTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              players = (players / 2).ceil();
              pids.removeRange(players, pids.length);
              names.removeRange(players, names.length);
            });
          },
          child: Container(
            height: 30,
            width: 30,
            child: Icon(
              Icons.remove,
              color: CustomColors.kAccentColor,
            ),
          ),
        ),
        Text(
          "$players Jugadores",
          style: CustomStyles.kTitleStyle,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              pids.addAll(List.generate(players, (index) => null));
              names.addAll(List.generate(players, (index) => null));
              players = players * 2;
            });
          },
          child: Container(
            height: 30,
            width: 30,
            child: Icon(
              Icons.add,
              color: CustomColors.kAccentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerSelector(Size size, int index) {
    return TextDataCard(
      title: "Jugador ${index + 1}",
      data: names[index] ?? "Seleccione Jugador",
      size: size,
      onTap: () {
        Navigator.of(context).pushNamed(SelectPlayerScreen.routeName).then(
          (value) {
            if (value == null) return;
            final Map<String, String> map = value;
            setState(() {
              pids[index] = map["id"];
              names[index] = map["name"];
            });
          },
        );
      },
    );
  }
}
