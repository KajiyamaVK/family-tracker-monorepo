import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/authentication/auth_controller.dart';
import 'package:mobile/features/authentication/auth_providers.dart';
import 'package:mobile/features/menu/menu_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'menu_page_test.mocks.dart';

@GenerateMocks([AuthController, GoRouter])
void main() {
  late MockAuthController mockAuthController;
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockAuthController = MockAuthController();
    mockGoRouter = MockGoRouter();
  });

  testWidgets('MenuPage displays all options and back button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuthController),
        ],
        child: MaterialApp(
          home: InheritedGoRouter(
            goRouter: mockGoRouter,
            child: const MenuPage(),
          ),
        ),
      ),
    );

    // Header
    expect(find.text('BACK'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Navigation Options
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Family'), findsOneWidget);
    expect(find.text('Add Location'), findsOneWidget);

    // Footer
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('Tapping Sign Out calls signOut on AuthController', (tester) async {
    // Setup mock to return a future when signOut is called
    when(mockAuthController.signOut()).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuthController),
        ],
        child: MaterialApp(
          home: InheritedGoRouter(
            goRouter: mockGoRouter,
            child: const MenuPage(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sign Out'));
    verify(mockAuthController.signOut()).called(1);
  });
}
