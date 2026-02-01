import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/features/map/infrastructure/google_map_service.dart';
import 'package:mobile/features/map/presentation/map_controller.dart';

/// Provider definition (overriding the Unimplemented one)
/// usually done in valid scope or main, but for now we can rely on override or simple definition here.
/// Actually, let's redefine mapServiceProvider here for real app usage if we were not using a global DI container.
/// In a real app, strict Clean Architecture might put this in a 'dependency_injection.dart' file.

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final state = ref.watch(mapControllerProvider);
    // We need the service instance to pass the controller to it.
    // In a cleaner setup, the Controller would handle this via a "setMapController" method exposed to UI?
    // Or we cast the service.
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
            myLocationEnabled: state.isPermissionGranted,
            myLocationButtonEnabled: state.isPermissionGranted,
            onMapCreated: (GoogleMapController controller) {
              if (mapService is GoogleMapService) {
                 mapService.onMapCreated(controller);
              }
              // Also verify the controller knows it's ready
              ref.read(mapControllerProvider.notifier).initializeMap();
            },
          ),
          if (state.currentLocation == null)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(mapControllerProvider.notifier).recenter();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
