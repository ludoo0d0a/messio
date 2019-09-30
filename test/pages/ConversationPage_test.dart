import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messio/pages/ConversationPage.dart';
import 'package:messio/widgets/ChatAppBar.dart';
import 'package:messio/widgets/ChatListWidget.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  const ConversationPage()
    ),
  );

  testWidgets('ConversationPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app);

    expect(find.byType(ChatAppBar),findsOneWidget);
    // Moved out to ConversationPageSlide
//    expect(find.byType(InputWidget),findsOneWidget);
    expect(find.byType(ChatListWidget),findsOneWidget);


  });
}
