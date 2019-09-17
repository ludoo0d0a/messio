import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

import 'ChatRowWidget.dart';
import 'NavigationPillWidget.dart';

class ConversationBottomSheetWidget extends StatefulWidget {
  ConversationBottomSheetWidget({Key key}) : super(key: key);

  @override
  _ConversationBottomSheetWidgetState createState() =>
      _ConversationBottomSheetWidgetState();
}

class _ConversationBottomSheetWidgetState
    extends State<ConversationBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          GestureDetector(
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                NavigationPillWidget(),
                Center(
                    child: Text('Messages')
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            onVerticalDragEnd: (details) {
              print('Dragged Down');
              if (details.primaryVelocity > 50) {
                Navigator.pop(context);
              }
            },
          ),

          ListView.separated(
            // Listview inside ListView requires these 2 attributes for proper scroll
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(left: 75,right: 20),
                child: Divider(
                  color: Palette.accentColor,
                )),
            itemBuilder: (context, index) {
              return ChatRowWidget();
            },
          )

        ],
      ),
    );
  }
}
