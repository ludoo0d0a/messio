import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messio/main.dart';
import 'package:messio/widgets/ChatListWidget.dart';

void main(){

  // Isolate component into a Material Scaffold
  MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  ChatListWidget()
    ),
  );

  testWidgets('ChatListWidget UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app);

    expect(find.byType(ListView),findsOneWidget);

  });
}
