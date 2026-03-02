import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neriya/features/map/infrastructure/google_map_service.dart';
import 'package:neriya/features/map/presentation/map_controller.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapControllerProvider);
    // We need the service instance to pass the controller to it.
    final mapService = ref.watch(mapServiceProvider);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            // Use the permission state directly for the blue dot
            myLocationEnabled: state.isPermissionGranted,
            myLocationButtonEnabled: state.isPermissionGranted,
            onMapCreated: (GoogleMapController controller) {
              if (mapService is GoogleMapService) {
                 mapService.onMapCreated(controller);
              }
              // Notify controller that the map renderer is ready
              ref.read(mapControllerProvider.notifier).initializeMap();
            },
          ),
          
          // CRITICAL FIX:
          // Changed from checking (currentLocation == null) to (!isReady).
          // This ensures the spinner disappears as soon as the Map renders,
          // even if the GPS location is still being fetched or timed out.
          if (!state.isReady)
            const ColoredBox(
              color: Colors.white, // Opaque background to hide the "yellow" map load
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Allow the user to manually trigger the location search again
          ref.read(mapControllerProvider.notifier).recenter();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}