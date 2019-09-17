import 'package:flutter/material.dart';
import 'package:messio/widgets/ConversationBottomSheetWidget.dart';
import 'package:messio/widgets/InputWidget.dart';

import 'ConversationPage.dart';

class ConversationPageSlide extends StatefulWidget {
  ConversationPageSlide({Key key}) : super(key: key);

  @override
  _ConversationPageSlideState createState() => _ConversationPageSlideState();
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {

  // dont forget key: _scaffoldKey, in Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        // Wrap PageView in Column > Expanded
        body: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                children: <Widget>[
                  ConversationPage(),
                  ConversationPage(),
                  ConversationPage()
                ],
              ),
            ),
            // Move out GestureDetector from ConversationPage to upper widget to isolate InputWidget
            GestureDetector(
                child: InputWidget(),
                onPanUpdate: (details) {
                  if (details.delta.dy <0) {
                    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
                      return ConversationBottomSheetWidget();
                    });
                  }
                })
          ],
        ),
      ),
    );
  }
}