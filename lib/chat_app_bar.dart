import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';


class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {

  final double height = 100;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(boxShadow: [ //adds a shadow to the appbar
          new BoxShadow(
            color: Colors.black,
            blurRadius: 5.0,
        )]),
        child: Container(
          color: Palette.primaryBackgroundColor,
          child:
            Text('Simple text')
        )
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
