import 'package:flutter/material.dart';
import 'package:flutter_application_lab_2/Hive.dart';
import 'package:flutter_application_lab_2/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_lab_2/main.dart';

void main() {
  group('UpdateJobScreen Widget Tests', () {
    testWidgets('Entering text in id field should update controllers',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FirestoreDeletePage()));
      final emailField = find.byKey(Key("id_field"));
      await tester.enterText(emailField, '1');
      await tester.pumpAndSettle();
    });

    testWidgets('Tap button in update job screen should update controllers',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FirestoreDeletePage()));
      final button = find.byKey(Key("Button"));
      await tester.tap(button);
      await tester.pumpAndSettle();
    });

testWidgets('Add and remove a todo', (tester) async {
  await tester.pumpWidget(const TodoList());

  await tester.enterText(find.byType(TextField), 'New Todo');
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();

  await tester.drag(find.byType(ListTile).first, const Offset(500, 0));

  await tester.pumpAndSettle();

  expect(find.text('New Todo'), findsNothing);
});

  });
}
