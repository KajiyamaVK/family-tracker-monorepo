import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/family/add_family_member_page.dart';

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
}
