import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/map/domain/entities/map_location.dart';
import 'package:mobile/features/map/domain/map_interface.dart';
import 'package:mobile/features/map/presentation/map_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockMapService extends Mock implements MapService {}

void main() {
  late MockMapService mockMapService;
  late MapController mapController;


  setUp(() {
    mockMapService = MockMapService();
    mapController = MapController(mockMapService);
    
    // Default stubs
    when(() => mockMapService.requestPermissions()).thenAnswer((_) async => false);
    registerFallbackValue(const MapLocation(latitude: 0, longitude: 0));
  });

  group('MapController', () {
    test('initial state is not ready', () {
      expect(mapController.state.isReady, isFalse);
    });

    test('initializeMap requests permissions, gets location, and moves camera', () async {
      const mockLocation = MapLocation(latitude: 37.7749, longitude: -122.4194);
      when(() => mockMapService.getCurrentLocation()).thenAnswer((_) async => mockLocation);
      when(() => mockMapService.moveCamera(mockLocation)).thenAnswer((_) async {});
      when(() => mockMapService.initialize()).thenAnswer((_) async {});
      when(() => mockMapService.requestPermissions()).thenAnswer((_) async => true);

      await mapController.initializeMap();

      // Allow background tasks (_locateUser) to complete
      await Future.delayed(Duration.zero);

      verify(() => mockMapService.requestPermissions()).called(1);
      verify(() => mockMapService.initialize()).called(1);
      verify(() => mockMapService.getCurrentLocation()).called(1);
      verify(() => mockMapService.moveCamera(mockLocation)).called(1);
      
      expect(mapController.state.isReady, isTrue);
      expect(mapController.state.isPermissionGranted, isTrue);
      expect(mapController.state.currentLocation, equals(mockLocation));
    });

    test('onLocationUpdate updates state and moves camera', () async {
      // Arrange
      const location = MapLocation(latitude: 37.7749, longitude: -122.4194);
      when(() => mockMapService.moveCamera(any())).thenAnswer((_) async {});

      // Act
      mapController.onLocationUpdate(location);

      // Assert
      expect(mapController.state.currentLocation, location);
      verify(() => mockMapService.moveCamera(location)).called(1);
    });
    test('recenter requests permission and moves camera', () async {
      const mockLocation = MapLocation(latitude: 37.7749, longitude: -122.4194);
      when(() => mockMapService.requestPermissions()).thenAnswer((_) async => true);
      when(() => mockMapService.getCurrentLocation()).thenAnswer((_) async => mockLocation);
      when(() => mockMapService.moveCamera(mockLocation)).thenAnswer((_) async {});

      await mapController.recenter();

      verify(() => mockMapService.requestPermissions()).called(1);
      verify(() => mockMapService.getCurrentLocation()).called(1);
      verify(() => mockMapService.moveCamera(mockLocation)).called(1);
    });
  });
}
