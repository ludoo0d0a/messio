import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';

import 'package:messio/widgets/ChatAppBar.dart';
import 'package:messio/widgets/ChatListWidget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentPage = 0;
  int age = 18;

  //this variable keeps track of the keyboard, when its shown and when its hidden
  var isKeyboardOpen = false;

  // this is the controller of the page.
  // This is used to navigate back and forth between the pages
  PageController pageController = PageController();

  //Fields related to animation of the gradient
  Alignment begin = Alignment.center;
  Alignment end = Alignment.bottomRight;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        begin = Alignment(pageController.page, pageController.page);
        end = Alignment(1 - pageController.page, 1 - pageController.page);
      });
    });

    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: begin, end: end, colors: [
              Palette.gradientStartColor,
              Palette.gradientEndColor
            ])),
        child: PageView(
          controller: pageController,
//          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int page) =>
              updatePageState(page),
          children: <Widget>[
            buidPageOne(),
            buidPageTwo(),
          ],
        )


      )
    );
  }

  Widget buidPageTwo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // space 100
          SizedBox(height: 100),
          // Avatar
          Container(
              child: CircleAvatar(
                backgroundImage: Image.asset(Assets.user).image,
                radius: 60,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 15,
                    ),
                    Text(
                        'Set Profile Picture',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
          ),
          // space 50
          SizedBox(height: 50),
          // Question Text
          Text(
            'How old are you?',
            style: Styles.questionLight,
          ),
          // Row > AgePicker
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Select years here...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),),
              Text('Years', style: Styles.textLight)
            ],
          ),
          // space 80
          SizedBox(height: 80),
          // Question username Container > Text
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Choose a username',
                style: Styles.questionLight,
              )
            ],
          ),
          // Container > Input
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 120,
            child: TextField(
              textAlign: TextAlign.center,
              style: Styles.subHeadingLight,
            ),
          )


        ],
      ),
    );
  }
  Widget buidPageOne() {
    return Container(
        child: Column(children: <Widget>[
      // Image
      Container(
          margin: EdgeInsets.only(top: 250),
          child: Image.asset(Assets.app_icon_fg, height: 100)),
      // Text
      Container(
          margin: EdgeInsets.only(top: 30),
          child: Text('Messio Messenger',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22))),
      // Login button
      Container(
          margin: EdgeInsets.only(top: 100),
          child: ButtonTheme(
              height: 40,
              child: FlatButton.icon(
                  onPressed: () => updatePageState(1),
                  color: Colors.transparent,
                  icon: Image.asset(
                    Assets.google_button,
                    height: 25,
                  ),
                  label: Text(
                    'Sign In with Google',
                    style: TextStyle(
                        color: Palette.primaryTextColorLight,
                        fontWeight: FontWeight.w800),
                  ))) // ButtonTheme
          ) // Container #3
    ]) // Column
        ); // container
  }

  updatePageState(int index) {
    if (index == 1)
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);

    setState(() {
      currentPage = index;
    });
  }
}
