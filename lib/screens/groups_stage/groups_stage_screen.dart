import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/components/category_tab_bar.dart';

import '../../screens/create_group/create_group.dart';
import '../../screens/groups_stage/components/groups_list.dart';
import '../../utils/colors.dart';
import '../../utils/custom_styles.dart';

class GroupStageScreen extends StatefulWidget {
  static const routeName = "/groups";
  @override
  _GroupStageScreenState createState() => _GroupStageScreenState();
}

class _GroupStageScreenState extends State<GroupStageScreen> {
  int selectedCategory = 0;

  void selectCategory(int cat) {
    setState(() {
      selectedCategory = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: CustomColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kAppBarColor,
        title: Text(
          "Grupos",
          style: CustomStyles.kAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CustomColors.kAccentColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: CustomColors.kAccentColor,
            ),
            onPressed: () => Navigator.of(context)
                .pushNamed(CreateGroup.routeName, arguments: tid),
          ),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Container(
            child: Column(
              children: [
                CategoryTabBar(options: [1,2,3],),
                Expanded(
                  child: TabBarView(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GroupsList(index + 1, tid),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
