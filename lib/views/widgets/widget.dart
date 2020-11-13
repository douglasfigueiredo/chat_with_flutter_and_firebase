import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context,
    {String title = "Chat Flutter", List<Widget> actions}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    actions: actions,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white54,
      ),
    ),
  );
}

TextStyle simpleTextStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle({Color textColor, TextDecoration decoration}) {
  return TextStyle(
    color: textColor,
    fontSize: 17,
    decoration: decoration,
  );
}
