import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/blocs/chats/model/Chat.dart';
import 'package:messio/blocs/contacts/model/contact.dart';
import 'package:messio/pages/ConversationBottomSheetWidget.dart';
import 'package:messio/widgets/InputWidget.dart';

import 'ConversationPage.dart';
import 'package:rubber/rubber.dart';

class ConversationPageSlide extends StatefulWidget {
  final Contact startContact;

  const ConversationPageSlide({this.startContact});

  @override
  _ConversationPageSlideState createState() => _ConversationPageSlideState(startContact);
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {

  final Contact startContact;
  ChatBloc chatBloc;
  List<Chat> chatList = List();
  bool isFirstLaunch = true;
  var controller;
  PageController pageController = PageController();

  // dont forget key: _scaffoldKey, in Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _ConversationPageSlideState(this.startContact);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    //  chatBloc.dispatch(FetchChatListEvent());
    controller = RubberAnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        // Wrap PageView in Column > Expanded
        body: Column(
          children: <Widget>[
            BlocListener<ChatBloc, ChatState>(
              bloc: chatBloc,
              listener: (bc, state) {
                print('ChatList $chatList');

                // In the ConversationPageSlide, we’ll receive the Contact,
                // compare it with the usernames in the ChatList we have,
                // get the index and scroll the PageView to that particular index.
                if (isFirstLaunch && chatList.isNotEmpty) {
                  isFirstLaunch = false;
                  for (int i = 0; i < chatList.length; i++) {
                    if (startContact.username == chatList[i].username) {
                      BlocProvider.of<ChatBloc>(context).dispatch(PageChangedEvent(i, chatList[i]));
                      pageController.jumpToPage(i);
                    }
                  }
                }



              },
              child: Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {

                      if (state is FetchedChatListState)
                        chatList = state.chatList;
                      return PageView.builder(
                          controller: pageController,
                          itemCount: chatList.length,
                          onPageChanged: (index) =>
                              BlocProvider.of<ChatBloc>(context).dispatch(
                                  PageChangedEvent(index, chatList[index])),
                          itemBuilder: (bc, index) =>
                              ConversationPage(chatList[index]));
//                      PageView.builder(
//                          itemCount: 500,
//                          itemBuilder: (index, context) {
//                            return ConversationPage();
//                          }
//                      )


                    }
                )
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