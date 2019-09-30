import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messio/pages/ConversationPage.dart';
import 'package:messio/pages/ConversationPageList.dart';

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  const MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  const ConversationPageList()
    ),
  );
  testWidgets('ConversationPageList UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app);
    expect(find.byType(ConversationPage),findsOneWidget);
    expect(find.byType(PageView),findsOneWidget);

  });
}