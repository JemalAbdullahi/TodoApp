import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';
import 'package:todolist/widgets/global_widgets/custom_appbar.dart';

class AddMembersPage extends StatelessWidget {
  final SearchBarController _searchBarController = SearchBarController();

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.width * 0.05;
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          appBar: CustomAppBar(
            "Add Members",
            actions: [],
          ),
          backgroundColor: Colors.transparent,
          body: SearchBar(
              searchBarController: _searchBarController,
              searchBarStyle: SearchBarStyle(
                padding: EdgeInsets.only(left: 15.0),
                backgroundColor: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              searchBarPadding: EdgeInsets.symmetric(horizontal: padding),
              icon: Icon(Icons.search, color: Colors.white),
              hintText: "Search Username",
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Segoe UI',
              ),
              onSearch: null,
              onItemFound: null),
        ),
      ),
    );
  }
}
