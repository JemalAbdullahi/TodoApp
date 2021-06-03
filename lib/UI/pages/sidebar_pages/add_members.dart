//import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/models/global.dart';
import 'package:todolist/models/group.dart';
import 'package:todolist/models/groupmember.dart';
import 'package:todolist/widgets/global_widgets/background_color_container.dart';

class AddMembersPage extends StatefulWidget {
  final Group group;

  const AddMembersPage({Key key, this.group}) : super(key: key);

  @override
  _AddMembersPageState createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  Size size;
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";

  List<GroupMember> searchResults = [];

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: BackgroundColorContainer(
        startColor: lightBlue,
        endColor: lightBlueGradient,
        widget: Scaffold(
          appBar: AppBar(
            title: _isSearching ? _buildSearchField() : _buildTitle(),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            toolbarHeight: 100.0,
            actions: _buildActions(),
            iconTheme:
                IconThemeData(color: Colors.black, size: 32.0, opacity: 1.0),
            leading: _isSearching
                ? IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
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
    );
  }

  Text _buildTitle() {
    return Text(
      "Add Members",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: "Segoe UI",
        fontSize: 32.0,
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
          fontSize: 24.0,
        ),
      ),
      style: TextStyle(
          color: Colors.white, fontSize: 24.0, fontFamily: "Segoe UI"),
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
          icon: const Icon(Icons.clear, color: Colors.red),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
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
                widget.group.members[index].cAvatar(radius: 25),
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
              fontSize: 30,
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
        leading: CircleAvatar(
          backgroundImage: searchResults[index].avatar,
        ),
        title: Text(
            "${searchResults[index].firstname} ${searchResults[index].lastname}"),
        subtitle: Text(searchResults[index].username),
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
              } else
                _addGroupMember(searchResults[index].username);
              this.setState(() {
                widget.group.addGroupMember(searchResults[index]);
              });
            }),
        /*CircularCheckBox(
          value: widget.group.members.contains(searchResults[index]),
          checkColor: Colors.white,
          activeColor: Colors.blue,
          inactiveColor: Colors.redAccent,
          disabledColor: Colors.grey,
          onChanged: (val) => this.setState(() {
            if (widget.group.members.contains(searchResults[index])) {
              widget.group.removeGroupMember(searchResults[index]);
            } else
              widget.group.addGroupMember(searchResults[index]);
          }),
        ),*/
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
      print(e.message);
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
