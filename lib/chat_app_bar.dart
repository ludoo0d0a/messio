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
          child: Row(
            children: <Widget>[
              //These are text items
              Expanded(
                flex: 7,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //first row containing the name and login
                      Container(
                        child: Text('name / login'),
                      ),
                      //second row containing the buttons for media (Photos / Videos / Files)
                      Container(
                        child: Text('Photos / Videos / Files'),
                      )
                    ],
                  )
                ),
              ),
              //This is the display picture
              Expanded(
                flex: 3,
                child: Center(
                  child: Text('Picture'),
                ),
              )

            ],
          )
        )
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
