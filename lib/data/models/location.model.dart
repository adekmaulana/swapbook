import 'package:location/location.dart' hide Location;

class Location {
  Location._(
    this.latitude,
    this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.speedAccuracy,
    this.heading,
    this.time,
    this.isMock,
    this.verticalAccuracy,
    this.headingAccuracy,
    this.elapsedRealtimeNanos,
    this.elapsedRealtimeUncertaintyNanos,
    this.satelliteNumber,
    this.provider,
  );

  /// Creates a new [LocationData] instance from a map.
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location._(
      json['latitude'] as double?,
      json['longitude'] as double?,
      json['accuracy'] is int
          ? json['accuracy'].toDouble()
          : json['accuracy'] as double?,
      json['altitude'] is int
          ? json['altitude'].toDouble()
          : json['altitude'] as double?,
      json['speed'] is int
          ? json['speed'].toDouble()
          : json['speed'] as double?,
      json['speed_accuracy'] is int
          ? json['speed_accuracy'].toDouble()
          : json['speed_accuracy'] as double?,
      json['heading'] is int
          ? json['heading'].toDouble()
          : json['heading'] as double?,
      json['time'] as double?,
      json['is_mock'] == 1,
      json['vertical_accuracy'] is int
          ? json['vertical_accuracy'].toDouble()
          : json['vertical_accuracy'] as double?,
      json['heading_accuracy'] as double?,
      json['elapsed_realtime_nanos'] as double?,
      json['elapsed_realtime_uncertainty_nanos'] as double?,
      json['satellite_number'] as int?,
      json['provider'] as String?,
    );
  }

  factory Location.fromLocationData(LocationData data) {
    return Location._(
      data.latitude,
      data.longitude,
      data.accuracy,
      data.altitude,
      data.speed,
      data.speedAccuracy,
      data.heading,
      data.time,
      data.isMock,
      data.verticalAccuracy,
      data.headingAccuracy,
      data.elapsedRealtimeNanos,
      data.elapsedRealtimeUncertaintyNanos,
      data.satelliteNumber,
      data.provider,
    );
  }

  /// Latitude in degrees
  final double? latitude;

  /// Longitude, in degrees
  final double? longitude;

  /// Estimated horizontal accuracy of this location, radial, in meters
  ///
  /// Will be null if not available.
  final double? accuracy;

  /// Estimated vertical accuracy of altitude, in meters.
  ///
  /// Will be null if not available.
  final double? verticalAccuracy;

  /// In meters above the WGS 84 reference ellipsoid. Derived from GPS informations.
  ///
  /// Will be null if not available.
  final double? altitude;

  /// In meters/second
  ///
  /// Will be null if not available.
  final double? speed;

  /// In meters/second
  ///
  /// Will be null if not available.
  /// Not available on web
  final double? speedAccuracy;

  /// Heading is the horizontal direction of travel of this device, in degrees
  ///
  /// Will be null if not available.
  final double? heading;

  /// timestamp of the LocationData
  final double? time;

  /// Is the location currently mocked
  ///
  /// Always false on iOS
  final bool? isMock;

  /// Get the estimated bearing accuracy of this location, in degrees.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getBearingAccuracyDegrees()
  final double? headingAccuracy;

  /// Return the time of this fix, in elapsed real-time since system boot.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getElapsedRealtimeNanos()
  final double? elapsedRealtimeNanos;

  /// Get estimate of the relative precision of the alignment of the ElapsedRealtimeNanos timestamp.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getElapsedRealtimeUncertaintyNanos()
  final double? elapsedRealtimeUncertaintyNanos;

  /// The number of satellites used to derive the fix.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getExtras()
  final int? satelliteNumber;

  /// The name of the provider that generated this fix.
  /// Only available on Android
  /// https://developer.android.com/reference/android/location/Location#getProvider()
  final String? provider;

  @override
  String toString() =>
      'LocationData<lat: $latitude, long: $longitude${(isMock ?? false) ? ', mocked' : ''}>';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy &&
          altitude == other.altitude &&
          speed == other.speed &&
          speedAccuracy == other.speedAccuracy &&
          heading == other.heading &&
          time == other.time &&
          isMock == other.isMock;

  @override
  int get hashCode =>
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      altitude.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      heading.hashCode ^
      time.hashCode ^
      isMock.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'speed_accuracy': speedAccuracy,
      'heading': heading,
      'time': time,
      'is_mock': isMock == true ? 1 : 0,
      'vertical_accuracy': verticalAccuracy,
      'heading_accuracy': headingAccuracy,
      'elapsed_realtime_nanos': elapsedRealtimeNanos,
      'elapsed_realtime_uncertainty_nanos': elapsedRealtimeUncertaintyNanos,
      'satellite_number': satelliteNumber,
      'provider': provider,
    };
  }
}
