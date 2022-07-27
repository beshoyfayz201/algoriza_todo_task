import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  Function(int) onTab;
int index;
   // ignore: use_key_in_widget_constructors
   BottomNavBar({
  required this.onTab,
    required this.index,
  }) ;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List icons = [Icons.list, Icons.done_all_outlined, Icons.archive_rounded];

  List labels = ["tasks", "done", "archived"];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
currentIndex:widget.index ,
onTap:widget.onTab ,
        items: List.generate(
            3,
            (index) => BottomNavigationBarItem(

                icon: Icon(icons[index]), label: labels[index])));
  }
}
