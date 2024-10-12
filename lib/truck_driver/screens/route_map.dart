import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteMap extends StatefulWidget {
  final String routeDetails;
  final LatLng startLocation;
  final LatLng endLocation;
  final List<LatLng> intermediateLocations;

  const RouteMap({
    super.key,
    required this.routeDetails,
    required this.startLocation,
    required this.endLocation,
    required this.intermediateLocations,
  });

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
    _checkInternetConnection();
    _getRoutePolyline(); // Fetch route from Directions API
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  // Method to get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled. Please enable them in your settings.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied. Please allow them.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied. Please allow them in settings.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  // Method to check internet connection
  void _checkInternetConnection() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool hasInternet = results.any((result) => result != ConnectivityResult.none);
      setState(() {
        _hasInternet = hasInternet;
      });

      if (!_hasInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection. Please check your connection.')),
        );
      }
    });
  }

  // Fetch route details from Google Directions API
  Future<void> _getRoutePolyline() async {
    String apiKey = 'AIzaSyDpwy79IM6EjuRUy0-lpf3wrkkfRvjuGsk'; // Replace with your Google API Key

    // Construct waypoints string for intermediate locations
    String waypoints = widget.intermediateLocations.map((location) {
      return '${location.latitude},${location.longitude}';
    }).join('|');

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${widget.startLocation.latitude},${widget.startLocation.longitude}&destination=${widget.endLocation.latitude},${widget.endLocation.longitude}&waypoints=$waypoints&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['routes'].isNotEmpty) {
          var points = data['routes'][0]['overview_polyline']['points'];
          _addPolyline(_decodePolyline(points));
        } else {
          print('No routes found in the response.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No route found between the specified points.')),
          );
        }
      } else {
        print('Error fetching directions: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch directions. Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching directions: $e')),
      );
    }
  }

  // Method to decode polyline
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return polyline;
  }

  // Add polyline to the map
  void _addPolyline(List<LatLng> points) {
    setState(() {
      _polyLines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        width: 4,
        color: Colors.green,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Internet'),
        ),
        body: const Center(
          child: Text('Please connect to the internet to view the map.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Name (Route Number)"),
      ),
      body: (_currentPosition == null)
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        ),
        myLocationEnabled: true,
        polylines: _polyLines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
