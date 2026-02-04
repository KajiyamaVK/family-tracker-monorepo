import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/features/authentication/auth_controller.dart';
import 'package:mobile/features/authentication/auth_providers.dart';
import 'package:mobile/features/authentication/login_page.dart';
import 'package:mobile/router.dart';
import 'package:mocktail/mocktail.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  String get email => 'test@example.com';
  @override
  String get displayName => 'Test User';
  @override
  String get id => '123';
  @override
  String? get photoUrl => null;
}

class FakeAuthController extends AuthController {
  FakeAuthController(super.googleSignIn, {AsyncValue<GoogleSignInAccount?>? initialState}) {
    if (initialState != null) {
      state = initialState;
    }
  }
}

void main() {
  group('Bottom Navigation Bar', () {
    late MockGoogleSignIn mockGoogleSignIn;
    late MockGoogleSignInAccount mockUser;

    setUp(() {
      mockGoogleSignIn = MockGoogleSignIn();
      mockUser = MockGoogleSignInAccount();
    });

    testWidgets('renders 4 navigation items', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith((ref) {
              return FakeAuthController(
                mockGoogleSignIn,
                initialState: AsyncValue.data(mockUser),
              );
            }),
          ],
          child: Consumer(builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
            );
          }),
        ),
      );
      
      // Manually pump to allow redirection
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      
      if (find.byType(LoginPage).evaluate().isNotEmpty) {
        debugPrint('Still on LoginPage');
      }

      // Find the NavigationBar
      final navBarFinder = find.byType(NavigationBar);
      expect(navBarFinder, findsOneWidget, reason: 'NavigationBar not found.');

      // Verify destionations
      expect(find.descendant(of: navBarFinder, matching: find.text('Home')), findsOneWidget);
      expect(find.text('Add Family'), findsOneWidget);
      expect(find.text('Add Location'), findsOneWidget);
      expect(find.text('Menu'), findsOneWidget);
      
      // Initial state should be Home
      expect(find.text('Bem-vindo,'), findsOneWidget); 
    });

    testWidgets('navigates to Add Family page', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
             authControllerProvider.overrideWith((ref) => FakeAuthController(
              mockGoogleSignIn,
              initialState: AsyncValue.data(mockUser),
            )),
          ],
          child: Consumer(builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
            );
          }),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Add Family
      await tester.tap(find.text('Add Family'));
      await tester.pumpAndSettle();

      expect(find.text('Add Family Member Placeholder'), findsOneWidget);
    });
   
    testWidgets('navigates to Add Location page', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
             authControllerProvider.overrideWith((ref) => FakeAuthController(
              mockGoogleSignIn,
              initialState: AsyncValue.data(mockUser),
            )),
          ],
          child: Consumer(builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
            );
          }),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Add Location
      await tester.tap(find.text('Add Location'));
      await tester.pumpAndSettle();

      expect(find.text('Add Location Placeholder'), findsOneWidget);
    });

    testWidgets('opens Menu drawer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
             authControllerProvider.overrideWith((ref) => FakeAuthController(
              mockGoogleSignIn,
              initialState: AsyncValue.data(mockUser),
            )),
          ],
          child: Consumer(builder: (context, ref, _) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
            );
          }),
        ),
      );
      
      await tester.pumpAndSettle();

      // Ensure we are initially at Home
      expect(find.text('Bem-vindo,'), findsOneWidget);

      // Tap on Menu
      await tester.tap(find.text('Menu'));
      await tester.pumpAndSettle();

      // Verify Drawer is open (looking for Menu Placeholder text within the drawer)
      // Since we haven't implemented the Drawer containing the menu yet, checking for the Drawer itself or content
      // The plan is to put MenuPage content in the drawer.
      // We expect the Home page content to STILL be there (behind the drawer)
      expect(find.text('Bem-vindo,'), findsOneWidget);
      
      // And we expect to see 'Menu Placeholder' which comes from MenuPage (which calls it 'Menu Placeholder')
      // Note: If MenuPage has a Scaffold, putting it in a Drawer might cause issues (nested Scaffolds), 
      // but for now let's assume we want to find the text.
      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
