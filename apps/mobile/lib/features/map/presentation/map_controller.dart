import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/map/domain/entities/map_location.dart';
import 'package:mobile/features/map/domain/map_interface.dart';

class MapState {
  const MapState({
    this.isReady = false,
    this.isPermissionGranted = false,
    this.currentLocation,
  });

  final bool isReady;
  final bool isPermissionGranted;
  final MapLocation? currentLocation;

  MapState copyWith({
    bool? isReady,
    bool? isPermissionGranted,
    MapLocation? currentLocation,
  }) {
    return MapState(
      isReady: isReady ?? this.isReady,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }
}

class MapController extends StateNotifier<MapState> {
  MapController(this._mapService) : super(const MapState());

  final MapService _mapService;

  Future<void> initializeMap() async {
    // Initialize service (waits for onMapCreated)
    await _mapService.initialize();
    
    // Mark as ready immediately so UI can respond
    state = state.copyWith(isReady: true);

    // Fetch location in background so we don't block initialization
    _locateUser();
  }

  Future<void> _locateUser() async {
    // Request permissions
    final granted = await _mapService.requestPermissions();
    if (granted) {
      state = state.copyWith(isPermissionGranted: true);
    }
    
    // Get current location
    final location = await _mapService.getCurrentLocation();
    
    if (location != null) {
      // Update state and move camera
      // Note: If we got a location, permission must be granted, so enforce true here too for safety.
      state = state.copyWith(
        currentLocation: location,
        isPermissionGranted: true, 
      );
      await _mapService.moveCamera(location);
    }
  }

  /// Public method to recenter the map on the user's location
  Future<void> recenter() => _locateUser();

  void onLocationUpdate(MapLocation location) {
    state = state.copyWith(currentLocation: location);
    _mapService.moveCamera(location);
  }
}

final mapServiceProvider = Provider<MapService>((ref) {
  throw UnimplementedError();
});

final mapControllerProvider = StateNotifierProvider<MapController, MapState>((ref) {
  final mapService = ref.watch(mapServiceProvider);
  return MapController(mapService);
});
