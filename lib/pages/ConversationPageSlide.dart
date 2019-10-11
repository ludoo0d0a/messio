import 'package:flutter/material.dart';
import 'package:messio/blocs/contacts/model/contact.dart';
import 'package:messio/pages/ConversationBottomSheetWidget.dart';
import 'package:messio/widgets/InputWidget.dart';

import 'ConversationPage.dart';

class ConversationPageSlide extends StatefulWidget {
  final Contact startContact;

  const ConversationPageSlide({this.startContact});

  @override
  _ConversationPageSlideState createState() => _ConversationPageSlideState(startContact);
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {

  final Contact startContact;

  // dont forget key: _scaffoldKey, in Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _ConversationPageSlideState(this.startContact);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        // Wrap PageView in Column > Expanded
        body: Column(
          children: <Widget>[
            Expanded(
              child:
              PageView.builder(
                  itemCount: 500,
                  itemBuilder: (index, context) {
                    return ConversationPage();
                  }
              )

//              PageView(
//                children: <Widget>[
//                  ConversationPage(),
//                  ConversationPage(),
//                  ConversationPage()
//                ],
//              ),


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