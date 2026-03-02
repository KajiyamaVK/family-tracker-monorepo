
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neriya/features/family/family_onboarding_page.dart';
import 'package:neriya/features/family/family_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'family_controller_test.mocks.dart';

@GenerateMocks([])
void main() {
  late MockFamilyRepository mockRepository;

  setUp(() {
    mockRepository = MockFamilyRepository();
  });

  testWidgets('FamilyOnboardingPage shows Create and Join options', (tester) async {
    // Mock initial null state (No Family)
    when(mockRepository.watchCurrentFamilyId()).thenAnswer((_) => Stream.value(null));
    when(mockRepository.createFamily(any)).thenAnswer((_) async {});
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          familyRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: FamilyOnboardingPage(),
        ),
      ),
    );
    await tester.pump(); // Allow stream to emit and update state

    expect(find.text('Create a New Family'), findsOneWidget);
    expect(find.text('Join an Existing Family'), findsOneWidget);
  });

  testWidgets('Clicking Join shows OTP input', (tester) async {
    when(mockRepository.watchCurrentFamilyId()).thenAnswer((_) => Stream.value(null));
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          familyRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          home: FamilyOnboardingPage(),
        ),
      ),
    );
    await tester.pump(); // Allow stream to emit and update state

    // Tap Join
    await tester.tap(find.text('Join an Existing Family'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Enter Invite Code'), findsOneWidget);
    expect(find.text('Join'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}
