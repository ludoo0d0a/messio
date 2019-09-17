import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Styles.dart';

class ChatRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.asset(
                    Assets.user,
                  ).image,
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text('John Doe', style: Styles.subHeading),
                      Text(
                        'What\'s up?',
                        style: Styles.subText,
                      )
                    ],
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
