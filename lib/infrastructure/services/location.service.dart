import 'package:get/get.dart' hide FormData;
import 'package:location/location.dart';

class LocationService extends GetxService {
  static bool? _serviceEnabled;
  static PermissionStatus? _permissionGranted;
  static Location? _location;

  get location => _location;
  get serviceEnabled => _serviceEnabled;
  get permissionGranted => _permissionGranted;
  static Future<LocationService> init() async {
    _location = Location();

    _serviceEnabled = await _location!.serviceEnabled();
    _permissionGranted = await _location!.hasPermission();

    // _location!.onLocationChanged.listen((LocationData currentLocation) async {
    //   await UpdateLocationUserCase().call(
    //     FormData.fromMap(
    //       {
    //         'latitude': currentLocation.latitude,
    //         'longitude': currentLocation.longitude,
    //         'accuracy': currentLocation.accuracy,
    //         'altitude': currentLocation.altitude,
    //         'speed': currentLocation.speed,
    //         'speed_accuracy': currentLocation.speedAccuracy,
    //         'heading': currentLocation.heading,
    //         'time': currentLocation.time,
    //         'is_mock': currentLocation.isMock == true ? 1 : 0,
    //         'vertical_accuracy': currentLocation.verticalAccuracy,
    //         'heading_accuracy': currentLocation.headingAccuracy,
    //         'elapsed_realtime_nanos': currentLocation.elapsedRealtimeNanos,
    //         'elapsed_realtime_uncertainty_nanos':
    //             currentLocation.elapsedRealtimeUncertaintyNanos,
    //         'satellite_number': currentLocation.satelliteNumber,
    //         'provider': currentLocation.provider,
    //       },
    //     ),
    //   );
    // });
    return LocationService();
  }

  Future<LocationData?> requestLocation() async {
    if (_location == null) {
      await init();
    }

    if (_serviceEnabled != true) {
      _serviceEnabled = await _location!.requestService();
      if (_serviceEnabled != true) {
        return null;
      }
    }

    if (_permissionGranted == null ||
        _permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location!.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await _location!.getLocation();
  }
}
