
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neriya/features/family/family_repository.dart';

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FakeFamilyRepository();
});

// Family State: Null = No Family, String = Family ID
// We can use AsyncValue to handle loading/error states during creation/joining.
final familyControllerProvider = StateNotifierProvider<FamilyController, AsyncValue<String?>>((ref) {
  final repo = ref.watch(familyRepositoryProvider);
  return FamilyController(repo);
});

class FamilyController extends StateNotifier<AsyncValue<String?>> {
  final FamilyRepository _repository;

  FamilyController(this._repository) : super(const AsyncValue.loading()) {
    _repository.watchCurrentFamilyId().listen((familyId) {
      if (mounted) {
        state = AsyncValue.data(familyId);
      }
    }, onError: (err, st) {
      if (mounted) {
        state = AsyncValue.error(err, st);
      }
    });
  }


  
  Future<void> createFamily(String name) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createFamily(name);
      // In a real app the stream would update, here we force the state
      state = const AsyncValue.data('new_family_id'); 
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> joinFamily(String otp) async {
    state = const AsyncValue.loading();
    try {
      await _repository.joinFamily(otp);
      state = const AsyncValue.data('joined_family_id');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  
  // Method to get invite code - usually this would be a separate provider or future
  Future<String> getInviteCode() {
    return _repository.getInviteCode();
  }
}
