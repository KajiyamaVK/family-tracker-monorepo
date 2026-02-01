class MapLocation {
  const MapLocation({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is MapLocation &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'MapLocation(lat: $latitude, lng: $longitude)';
}
