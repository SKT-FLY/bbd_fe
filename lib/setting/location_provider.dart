import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  bool _locationPermissionGranted = false;
  Position? _currentPosition;

  bool get isLocationPermissionGranted => _locationPermissionGranted;
  Position? get currentPosition => _currentPosition;

  Future<void> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _locationPermissionGranted = true;
      await _getCurrentLocation();
    } else {
      _locationPermissionGranted = false;
    }

    notifyListeners();
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
