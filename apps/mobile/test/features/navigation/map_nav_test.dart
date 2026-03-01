import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neriya/features/authentication/auth_controller.dart';
import 'package:neriya/features/authentication/auth_providers.dart';
import 'package:neriya/features/map/domain/map_interface.dart';
import 'package:neriya/features/map/presentation/map_controller.dart';
import 'package:neriya/router.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
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

class MockMapService extends Mock implements MapService {}

void main() {
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockUser;
  late MockMapService mockMapService;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockUser = MockGoogleSignInAccount();
    mockMapService = MockMapService();
  });

  testWidgets('Navbar is visible when navigating to MapPage', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => FakeAuthController(
            mockGoogleSignIn,
            initialState: AsyncValue.data(mockUser),
          )),
          mapServiceProvider.overrideWithValue(mockMapService),
          mapControllerProvider.overrideWith((ref) {
             final service = ref.watch(mapServiceProvider);
             final controller = MapController(service);
             // Manually set ready state to avoid infinite progress indicator
             controller.state = const MapState(isReady: true);
             return controller;
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

    await tester.pumpAndSettle();

    // Verify we are on Home Page
    expect(find.text('Abrir Mapa'), findsOneWidget);
    
    // Tap on Open Map button
    await tester.tap(find.text('Abrir Mapa'));
    await tester.pumpAndSettle();

    // Verify we are on Map Page (check for a specific widget or text key if possible, 
    // but MapPage has a GoogleMap which might be tricky, checking unrelated widgets usually works)
    // Here we check for presence of Navbar
    final navBarFinder = find.byType(NavigationBar);
    expect(navBarFinder, findsOneWidget, reason: 'NavigationBar should be visible on MapPage');
  });
}
