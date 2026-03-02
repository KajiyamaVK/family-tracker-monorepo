
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neriya/features/family/family_provider.dart';
import 'package:neriya/features/family/family_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'family_controller_test.mocks.dart';

@GenerateMocks([FamilyRepository])
void main() {
  late MockFamilyRepository mockRepository;

  setUp(() {
    mockRepository = MockFamilyRepository();
    when(mockRepository.watchCurrentFamilyId()).thenAnswer((_) => Stream.value(null));
  });

  FamilyController createController(ProviderContainer container) {
    return container.read(familyControllerProvider.notifier);
  }

  test('Initial state is AsyncData(null)', () async {
    final container = ProviderContainer(
      overrides: [
        familyRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);



    container.read(familyControllerProvider);
    // Allow stream to emit
    await Future.delayed(Duration.zero);
    
    expect(container.read(familyControllerProvider), const AsyncValue<String?>.data(null));
  });

  test('createFamily updates state on success', () async {
    final container = ProviderContainer(
      overrides: [
        familyRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    final controller = createController(container);

    when(mockRepository.createFamily(any)).thenAnswer((_) async {});

    await controller.createFamily('Test Family');

    final state = container.read(familyControllerProvider);
    expect(state.value, isNotNull);
    // In our simplified implementation, we set a dummy ID 'new_family_id'
    expect(state.value, 'new_family_id');
    verify(mockRepository.createFamily('Test Family')).called(1);
  });

  test('joinFamily updates state on success', () async {
    final container = ProviderContainer(
      overrides: [
        familyRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    final controller = createController(container);

    when(mockRepository.joinFamily(any)).thenAnswer((_) async {});

    await controller.joinFamily('123456');

    final state = container.read(familyControllerProvider);
    expect(state.value, 'joined_family_id');
    verify(mockRepository.joinFamily('123456')).called(1);
  });
  
  test('joinFamily sets error state on failure', () async {
    final container = ProviderContainer(
      overrides: [
        familyRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    addTearDown(container.dispose);
    final controller = createController(container);

    when(mockRepository.joinFamily(any)).thenAnswer((_) async => throw Exception('Invalid OTP'));

    await controller.joinFamily('bad_otp');


    expect(container.read(familyControllerProvider).hasError, true);
  });
}
