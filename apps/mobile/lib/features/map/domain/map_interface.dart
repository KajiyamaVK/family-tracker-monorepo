import 'package:neriya/features/map/domain/entities/map_location.dart';

/// Defines the capabilities of the Map Service.
/// This abstraction allows us to test logic without the actual Google Maps plugin.
abstract class MapService {
  /// Initializes the map service.
  Future<void> initialize();

  /// Requests location permissions.
  Future<bool> requestPermissions();

  /// Gets the user's current location.
  Future<MapLocation?> getCurrentLocation();

  /// Moves the camera to a specific location.
  Future<void> moveCamera(MapLocation location);

  /// Updates the markers on the map.
  /// For now, we just pass locations, but this could be a list of Marker objects.
  Future<void> updateMarkers(List<MapLocation> locations);
  
  /// Stream of the current user's location updates.
  Stream<MapLocation> get locationUpdates;
}
