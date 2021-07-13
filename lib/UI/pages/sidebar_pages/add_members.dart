//import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';

class AddMembersPage extends StatefulWidget {
  final Group group;

  const AddMembersPage({Key? key, required this.group}) : super(key: key);

  @override
  _AddMembersPageState createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  late Size size;
  late double unitHeightValue;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  List<GroupMember> searchResults = [];

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    unitHeightValue = size.height * 0.001;
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: _isSearching ? _buildSearchField() : _buildTitle(),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation: 0.0,
              toolbarHeight: 100.0,
              actions: _buildActions(),
              iconTheme: IconThemeData(
                  color: Colors.black,
                  size: 32.0 * unitHeightValue,
                  opacity: 1.0),
              leading: _isSearching
                  ? IconButton(
                      icon: Icon(Icons.keyboard_arrow_down,
                          size: 30 * unitHeightValue),
                      onPressed: () => FocusScope.of(context).unfocus(),
                    )
                  : BackButton(),
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [_buildColumnCard()],
            ),
          ),
        ),
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      "Add Members",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: "Segoe UI",
        fontSize: 32.0 * unitHeightValue,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Users...",
        border: InputBorder.none,
        hintStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Segoe UI",
            fontSize: 24.0 * unitHeightValue),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0 * unitHeightValue,
        fontFamily: "Segoe UI",
      ),
      onChanged: (query) {
        if (query.length >= 2) {
          updateSearchQuery(query);
        }
      },
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon:
              Icon(Icons.clear, color: Colors.red, size: 30 * unitHeightValue),
          onPressed: () {
            /* if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              return;
            } */
            Navigator.pop(context);
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: Icon(Icons.search, size: 30 * unitHeightValue),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      if (searchQuery.isNotEmpty) getUsers();
    });
  }

  void getUsers() async {
    searchResults = await repository.searchUser(searchQuery);
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      searchResults = [];
      _isSearching = false;
      updateSearchQuery("");
    });
  }

  Column _buildColumnCard() {
    return Column(children: [
      Container(
          height: size.height * 0.12,
          width: size.width,
          child: _addedMembersListView()),
      _expandedCard(),
    ]);
  }

  ListView _addedMembersListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final member = widget.group.members[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Dismissible(
            key: Key(member.username),
            direction: DismissDirection.down,
            onDismissed: (direction) async {
              setState(() {
                widget.group.removeGroupMember(member);
              });
              _deleteGroupMember(member.username);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Removed ${member.username}"),
                ),
              );
            },
            child: Column(
              children: [
                widget.group.members[index]
                    .cAvatar(radius: 25, unitHeightValue: unitHeightValue),
                Text(
                  widget.group.members[index].firstname,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: widget.group.members.length,
    );
  }

  Expanded _expandedCard() {
    return Expanded(child: _containerMembers());
  }

  Container _containerMembers() {
    double containerHeight = size.height * 0.6;
    return Container(
      height: containerHeight,
      width: size.width,
      padding: EdgeInsets.only(left: 24.0, top: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(50.0),
        ),
      ),
      child: Stack(
        children: [
          Text(
            "USERS",
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontWeight: FontWeight.bold,
              color: darkBlue,
              fontSize: 30 * unitHeightValue,
            ),
          ),
          paddingList()
        ],
      ),
    );
  }

  Padding paddingList() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: searchResultListView(),
    );
  }

  ListView searchResultListView() {
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        leading: searchResults[index]
            .cAvatar(unitHeightValue: unitHeightValue, radius: 16),
        title: Text(
          "${searchResults[index].firstname} ${searchResults[index].lastname}",
          style: TextStyle(fontSize: 20 * unitHeightValue),
        ),
        subtitle: Text(
          searchResults[index].username,
          style: TextStyle(fontSize: 16 * unitHeightValue),
        ),
        trailing: Checkbox(
            value: widget.group.members.contains(searchResults[index]),
            checkColor: Colors.white,
            activeColor: Colors.blue,
            onChanged: (val) {
              if (widget.group.members.contains(searchResults[index])) {
                _deleteGroupMember(searchResults[index].username);
                this.setState(() {
                  widget.group.removeGroupMember(searchResults[index]);
                });
              } else if (!widget.group.members.contains(searchResults[index])) {
                _addGroupMember(searchResults[index].username);
                this.setState(() {
                  widget.group.addGroupMember(searchResults[index]);
                });
              }
            }),
      ),
      separatorBuilder: (context, index) => Divider(),
      itemCount: searchResults.length,
    );
  }

  //delete memeber from group dbtable
  Future<void> _deleteGroupMember(String username) async {
    try {
      await repository.deleteGroupMember(widget.group.groupKey, username);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addGroupMember(String username) async {
    try {
      await repository.addGroupMember(widget.group.groupKey, username);
    } catch (e) {
      print(e);
    }
  }
}
