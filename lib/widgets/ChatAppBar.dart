import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';


class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {

  const ChatAppBar();

  final double height = 100;

  @override
  Widget build(BuildContext context) {

    var textHeading = TextStyle(color: Palette.primaryTextColor, fontSize: 20); // Text style for the name
    var textStyle = TextStyle(color: Palette.secondaryTextColor); // Text style for everything else

//    double width = MediaQuery.of(context).size.width; // calculate the screen width

    return Material(
      child: Container(
        decoration: new BoxDecoration(boxShadow: [ //adds a shadow to the appbar
          new BoxShadow(
            color: Colors.black,
            blurRadius: 5.0,
        )]),
        child: Container(
          color: Palette.primaryBackgroundColor,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //first row containing the name and login
                      Expanded(
                        flex: 7,
                        child: Container(
//                            height: 70 - (width * .06),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // 2/8 : left icon
                              Expanded(
                              flex: 2,
                              child: Center(
                                  child: Icon(
                                    Icons.attach_file,
                                    color: Palette.secondaryColor,
                                  ))),
                              // 6/8 : texts on 2 rows
                              Expanded(
                                flex: 6,
                                child: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,

                                      children: <Widget>[
                                        Text('Ludo Valente', style: textHeading),
                                        Text('@ludoo0d0a', style: textStyle)
                                      ],
                                    )
                                ),
                              )

                            ],
                          )
                        ),
                      ),
                      //second row containing the buttons for media (Photos / Videos / Files)
                      Expanded(
                        flex: 3,
                        child: Container(
                          // height: 23,
                          padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Photos',
                                style: textStyle,
                              ),
                              VerticalDivider(
                                width: 30,
                                color: Palette.primaryTextColor,
                              ),
                              Text(
                                'Videos',
                                style: textStyle,
                              ),
                              VerticalDivider(
                                width: 30,
                                color: Palette.primaryTextColor,
                              ),
                              Text('Files', style: textStyle)
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ),
              ),
              //This is the display picture
              Expanded(
                flex: 3,
                child: Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: Image.asset(
                        Assets.user,
                      ).image,
                    )
                  ),
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
