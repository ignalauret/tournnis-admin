import 'package:flutter/material.dart';
import 'package:tournnis_admin/components/category_selector.dart';
import 'package:tournnis_admin/screens/create_group/create_group.dart';
import 'package:tournnis_admin/screens/groups_stage/components/groups_list.dart';
import 'package:tournnis_admin/utils/colors.dart';

class GroupStageScreen extends StatefulWidget {
  static const routeName = "/groups";
  @override
  _GroupStageScreenState createState() => _GroupStageScreenState();
}

class _GroupStageScreenState extends State<GroupStageScreen> {
  int selectedCategory = 0;

  // void selectCategory(int cat) {
  //   setState(() {
  //     selectedCategory = cat;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final String tid = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: CustomColors.kMainColor,
      appBar: AppBar(
        title: Text("Grupos de platino"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(CreateGroup.routeName, arguments: tid),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              // CategorySelector.withAll(
              //   select: selectCategory,
              //   selectedCat: selectedCategory,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GroupsList(selectedCategory, tid),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
