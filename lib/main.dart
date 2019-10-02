import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/authentication/authentication_event.dart';
import 'package:messio/pages/ConversationPageSlide.dart';
//import 'package:messio/pages/ConversationPageSlide.dart';
import 'package:messio/pages/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/SharedObjects.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_state.dart';
import 'blocs/authentication/repository/AuthenticationRepository.dart';
import 'blocs/authentication/repository/StorageRepository.dart';
import 'blocs/authentication/repository/UserDataRepository.dart';
import 'blocs/contacts/bloc.dart';
import 'config/Palette.dart';

Future<void> main() async {
  // Line required : https://github.com/felangel/hydrated_bloc/issues/17
  WidgetsFlutterBinding.ensureInitialized();

  //create instances of the repositories to supply them to the app
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();

  SharedObjects.prefs = await SharedPreferences.getInstance();

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              builder: (context) => AuthenticationBloc(
                  authenticationRepository: authRepository,
                  userDataRepository: userDataRepository,
                  storageRepository: storageRepository
              )
                ..dispatch(AppLaunched()),
              child: MessioApp(),
            ),
            BlocProvider<ContactsBloc>(
              builder: (context) => ContactsBloc(
                userDataRepository: userDataRepository,
              ),
            )
          ],
          child: MessioApp(),
      )
  );
}


//=> runApp(MessioApp());

class MessioApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
      ),
//      home: ConversationPageSlide(),
//      home: ConversationPageList(),
//      home: RegisterPage(),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is UnAuthenticated) {
              return RegisterPage();
            } else if (state is ProfileUpdated) {
              return ConversationPageSlide();
            } else {
              return RegisterPage();
            }
          }
      ),
    );
  }
}
