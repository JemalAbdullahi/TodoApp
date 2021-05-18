import 'package:flutter/material.dart';

class DropdownModel {
  const DropdownModel({
    this.dropdown,
    this.label = '',
    this.isDropdownOpen = false,
  });

  final String label;
  final bool isDropdownOpen;
  final Widget dropdown;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final DropdownModel otherModel = other;
    return (otherModel.label == label) &&
        (otherModel.isDropdownOpen == isDropdownOpen);
  }

  @override
  int get hashCode => label.hashCode;

  static DropdownModel of(BuildContext context) {
    final _CustomDropdownScope scope =
        context.dependOnInheritedWidgetOfExactType<_CustomDropdownScope>();
    return scope.customDropdownState.currentDropdown;
  }

  static void update(BuildContext context, DropdownModel newDropdown) {
    final _CustomDropdownScope scope =
        context.dependOnInheritedWidgetOfExactType<_CustomDropdownScope>();
    scope.customDropdownState.updateDropdown(newDropdown);
  }
}

class _CustomDropdownScope extends InheritedWidget {
  final _CustomDropdownState customDropdownState;

  _CustomDropdownScope(
      {Key key, @required this.customDropdownState, Widget child})
      : assert(customDropdownState != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomDropdownScope old) => true;
}

class CustomDropdown extends StatefulWidget {
  /* final bool selected;

  const CustomDropdown({Key key, @required this.selected, this.parentAction})
      : super(key: key); */

  final DropdownModel initialDropdown;
  final Widget child;
  final ValueChanged<bool> parentAction;

  CustomDropdown(
      {Key key,
      this.initialDropdown = const DropdownModel(
        label: 'Select Group',
      ),
      this.parentAction,
      this.child})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  DropdownModel currentDropdown;

  //GlobalKey _actionKey;
  //String _dropdownValue;
  //bool _isDropdownOpen = false;
  //double height, width, xPosition, yPosition;
  OverlayEntry _floatingDropDown;

  @override
  void initState() {
    currentDropdown = widget.initialDropdown;
    //_actionKey = LabeledGlobalKey(currentDropdown.label);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _CustomDropdownScope(customDropdownState: this, child: widget.child);
  }

  void updateDropdown(DropdownModel newDropdown) {
    if (newDropdown != currentDropdown) {
      setState(() {
        currentDropdown = newDropdown;
        if (currentDropdown.isDropdownOpen) {
          //print("Open Dropdown");
          _floatingDropDown = _createFloatingDropdown();
          Overlay.of(context).insert(_floatingDropDown);
          _dismissKeyboard();
        } else if (_floatingDropDown != null) {
          //print("Closed Dropdown");
          _floatingDropDown.remove();
        }
      });
    }
  }

  _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      print("dismiss Keyboard");
      currentFocus.unfocus();
    }
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return currentDropdown.dropdown;
      },
    );
  }
/*
  OverlayEntry _createFloatingDropdown() {
    width = MediaQuery.of(context).size.width;
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          height: 230,
          bottom: 0.0,
          width: width,
          child: DropDown(
            itemHeight: 50,
          ),
        );
      },
    );
  }
void findDropdownData() {
    //RenderBox renderBox = _actionKey.currentContext.findRenderObject();
    //height = renderBox.size.height;
    width = MediaQuery.of(context).size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    //print("Height: $height");
    //print("Width: $width");
    //print("X: $xPosition");
    //print("Y: $yPosition");
  }

  closeCustomDropdown() {
    if (currentDropdown.isDropdownOpen) {
      _floatingDropDown.remove();
      //_isDropdownOpen = !_isDropdownOpen;
      //widget.parentAction(_isDropdownOpen);
    }
    //print("Is Dropdown Open? $_isDropdownOpen \nIs TextField Selected? ${widget.selected}");
  }

  @override
  Widget build(BuildContext context) {
    return (widget.selected || _isDropdownOpen)
        ? GestureDetector(
            key: _actionKey,
            onTap: () {
              setState(() {
                if (_isDropdownOpen) {
                  _floatingDropDown.remove();
                } else {
                  findDropdownData();
                  _floatingDropDown = _createFloatingDropdown(context);
                  Overlay.of(context).insert(_floatingDropDown);
                  _dismissKeyboard();
                }
                _isDropdownOpen = !_isDropdownOpen;
                widget.parentAction(_isDropdownOpen);
              });
            },
            child: Container(
              child: Row(
                children: [
                  Text(
                    InheritedDropdown.of(context).label,
                    style: TextStyle(color: Colors.black54),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.black54),
                ],
              ),
            ),
          )
        : SizedBox();
  } 
  */
}

class DropDownViewController extends StatelessWidget {
  Widget _dropdown(double width, bool isDropdownOpen) {
    return isDropdownOpen
        ? Positioned(
            height: 230,
            bottom: 0.0,
            width: width,
            child: DropDown(
              itemHeight: 50,
            ),
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final DropdownModel dropdownModel = DropdownModel.of(context);
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      key: UniqueKey(),
      onTap: () {
        DropdownModel.update(
          context,
          DropdownModel(
            dropdown: _dropdown(width, !dropdownModel.isDropdownOpen),
            label: dropdownModel.label,
            isDropdownOpen: !dropdownModel.isDropdownOpen,
          ),
        );
        print(!dropdownModel.isDropdownOpen);
      },
      child: Container(
        child: Row(
          children: [
            Text(
              dropdownModel.label,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

//////////

class DropDown extends StatelessWidget {
  final double itemHeight;

  const DropDown({Key key, this.itemHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Material(
          elevation: 40,
          type: MaterialType.transparency,
          child: Container(
            height: (4 * itemHeight) + 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(50.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
            child: Column(
              children: <Widget>[
                DropDownItem(
                  group: "Family",
                  height: itemHeight,
                ),
                DropDownItem(group: "School", height: itemHeight),
                DropDownItem(group: "Personal", height: itemHeight),
                DropDownItem(group: "Work", height: itemHeight),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatefulWidget {
  final String group; //change to Group later
  final double height;

  DropDownItem({Key key, this.group, this.height}) : super(key: key);

  @override
  _DropDownItemState createState() => _DropDownItemState();
}

class _DropDownItemState extends State<DropDownItem> {
  GlobalKey _actionKey;
  bool isSelected = false;

  @override
  void initState() {
    _actionKey = LabeledGlobalKey(widget.group);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _actionKey,
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.group,
              style: TextStyle(
                //fontFamily: 'Segoe UI',
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                //decoration: TextDecoration.none,
              ),
            ),
            Icon(
              Icons.check,
              size: isSelected ? 24.0 : 0.0,
            )
          ],
        ),
      ),
    );
  }
}

/*  
DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['No Group', 'Group One', 'Group Two', 'Group Three']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ); 
*/
