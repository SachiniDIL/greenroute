import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RouteMap extends StatefulWidget {
  final String routeDetails; // Route path details
  final LatLng startLocation; // Route starting location
  final LatLng endLocation; // Route ending location

  const RouteMap({required this.routeDetails, required this.startLocation, required this.endLocation});

  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  late GoogleMapController _mapController;
  Position? _currentPosition;
  final Set<Polyline> _polyLines = {};
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _checkInternetConnection(); // Ensure this is called to initialize the subscription
    _createRoutePolyline();
  }

  @override
  void dispose() {
    // Check if the subscription has been initialized before cancelling
    connectivitySubscription?.cancel();
    super.dispose();
  }

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    print('Checking location services...');
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled. Please enable them in your settings.')),
      );
      return;
    }

    // Check for location permissions
    print('Requesting location permissions...');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied. Please allow them.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied. Please allow them in settings.')),
      );
      return;
    }

    // If everything is fine, get the current location
    print('Getting current location...');
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current location: ${position.latitude}, ${position.longitude}');
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location.')),
      );
    }
  }

  // Method to check internet connection
  void _checkInternetConnection() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Here we can check each result in the list to determine connectivity
      bool hasInternet =
      results.any((result) => result != ConnectivityResult.none);

      setState(() {
        _hasInternet = hasInternet;
      });

      if (!_hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No internet connection. Please check your connection.')),
        );
      }
    });
  }

  // Method to create polyline for route
  void _createRoutePolyline() {
    _polyLines.add(
      Polyline(
        polylineId: PolylineId("route"),
        visible: true,
        points: [widget.startLocation, widget.endLocation],
        // Add actual route points here
        width: 4,
        color: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: Text('No Internet'),
        ),
        body: Center(
          child: Text('Please connect to the internet to view the map.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Route Name (Route Number)"),
      ),
      body: (_currentPosition == null)
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              _currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        ),
        myLocationEnabled: true, // Show user's current location
        polylines: _polyLines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
