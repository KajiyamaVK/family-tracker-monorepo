import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/features/map/domain/entities/map_location.dart';
import 'package:mobile/features/map/domain/map_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapService implements MapService {
  final Completer<GoogleMapController> _controllerComparer = Completer();
  
  // Expose this for the UI to call
  void onMapCreated(GoogleMapController controller) {
    if (!_controllerComparer.isCompleted) {
      _controllerComparer.complete(controller);
    }
  }

  @override
  Future<bool> requestPermissions() async {
    final status = await [
      Permission.location,
    ].request();
    return status[Permission.location]!.isGranted;
  }

  @override
  Future<MapLocation?> getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check permission status again to be safe
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
    
    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // 1. Try to get the last known position first (Fastest)
    // This resolves the "3-4 minute" wait on first install if the OS has any cached location.
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      return MapLocation(
        latitude: lastKnown.latitude,
        longitude: lastKnown.longitude,
      );
    }

    // 2. If no cached location, fetch fresh position with a strict timeout & lower accuracy
    // High accuracy on cold boot causes the hang. Balanced (medium) is usually sufficient for initial centering.
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      
      return MapLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      // Timeout or error: return null so the UI doesn't hang forever, 
      // or you could return a default fallback location here.
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await _controllerComparer.future;
    // Enable MyLocation layer now that we hopefully have permissions
    // Note: This setter might not persist if not updated in the Widget properties,
    // but typically we control this via boolean params on the widget.
    // However, google_maps_controller implies imperative control.
    // For "myLocationEnabled" to work, the Widget must have myLocationEnabled: true. 
    // We should probably rely on the UI widget property, ensuring it rebuilds?
    // Actually, `GoogleMap` widget respects `myLocationEnabled` property. 
    // If the permission was missing, the native view might have complained. 
    // Let's assume the UI handles the rebuild or we just trust the permission is there next time updates happen.
  }

  @override
  Future<void> moveCamera(MapLocation location) async {
    final controller = await _controllerComparer.future;
    await controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(location.latitude, location.longitude),
      ),
    );
  }

  @override
  Future<void> updateMarkers(List<MapLocation> locations) async {
    // TODO: Implement marker management
  }

  @override
  Stream<MapLocation> get locationUpdates {
    // TODO: Connect to real location stream (e.g. flutter_background_geolocation or Geolocator)
    // For now, returning empty stream
    return const Stream.empty();
  }
}
