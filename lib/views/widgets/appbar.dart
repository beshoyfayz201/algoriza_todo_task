import 'package:flutter/material.dart';

AppBar buildAppbar(
    {required BuildContext context,
    required String txt,
    Widget? leading,
    List<Widget>? actions}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Text(
      txt,
      style:const TextStyle(color: Colors.black, fontFamily: "k", fontSize: 30),
    ),
    actions: actions,
    leading: txt != "Board"
        ? IconButton(
            icon:const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.pop(context);
            })
        : null,
  );
}
