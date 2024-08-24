import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({Key? key}) : super(key: key);

  @override
  _GpsScreenState createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  String? latitude;
  String? longitude;
  String? error;

  Future<void> getGeoData() async {
    try {
      print("Checking location permissions...");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print("Location permission denied. Requesting permission...");
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            error = 'Location permissions are denied';
          });
          print(error);  // Debug message
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          error =
          'Location permissions are permanently denied, we cannot request permissions.';
        });
        print(error);  // Debug message
        return;
      }

      print("Getting current position...");
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        error = null;  // Reset error if successful
      });
      print("Latitude: $latitude, Longitude: $longitude");  // Debug message
    } catch (e) {
      setState(() {
        error = 'Failed to get location: $e';
      });
      print(error);  // Debug message
    }
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI with latitude: $latitude and longitude: $longitude");  // 추가된 디버그 메시지
    return Scaffold(
      appBar: AppBar(title: const Text("GPS Screen")),
      body: Container(
        color: Colors.blueAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Current Location',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              else ...[
                Text(
                  'Latitude: ${latitude ?? "Loading..."}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Longitude: ${longitude ?? "Loading..."}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}