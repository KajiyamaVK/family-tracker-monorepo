import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neriya/features/family/add_family_member_page.dart';

void main() {
  testWidgets('AddFamilyMemberPage shows form fields and send button',
      (WidgetTester tester) async {
    // pump the widget
    await tester.pumpWidget(const MaterialApp(home: AddFamilyMemberPage()));

    // Verify that the title is present
    expect(find.text('Add Family Member'), findsOneWidget);

    // Verify Name field is present (looking for label text)
    expect(find.widgetWithText(TextFormField, 'Name'), findsOneWidget);

    // Verify Email field is present (looking for label text)
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);

    // Verify Send button is present
    expect(find.widgetWithText(ElevatedButton, 'Send'), findsOneWidget);
  });

  testWidgets('Name field capitalizes first letter of each word',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddFamilyMemberPage()));

    final nameFinder = find.widgetWithText(TextFormField, 'Name');
    await tester.enterText(nameFinder, 'john doe');
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('Email field converts to lowercase',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddFamilyMemberPage()));

    final emailFinder = find.widgetWithText(TextFormField, 'Email');
    await tester.enterText(emailFinder, 'Test@Example.com');
    await tester.pump();

    expect(find.text('test@example.com'), findsOneWidget);
  });
}
