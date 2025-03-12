import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:par/model/search_query.dart';
import 'package:par/screens/login_screen.dart';
import 'package:par/search/search_area.dart'; // For location services
import 'package:shared_preferences/shared_preferences.dart';

class ParkingHomePage extends StatefulWidget {
  @override
  _ParkingHomePageState createState() => _ParkingHomePageState();
}

class _ParkingHomePageState extends State<ParkingHomePage> {
  late GoogleMapController mapController;
  List<ParkingLocation> parkingLocations = [];
  bool isLoading = false;
  String searchQuery = '';
  Set<Marker> markers = {};
  LatLng? currentLocation; // Store user's current location
  bool showAllParkingPlaces = false; // Track if "View All" is clicked
  ParkingLocation? selectedLocation; // Track the selected location
  bool showAllNearestPlaces =
      false; // Track if "View All" is clicked for nearest places

  // ScrollController for AppBar background color change
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch user's current location
    fetchParkingLocations();

    // Add scroll listener
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener to update AppBar background color
  void _scrollListener() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  // Fetch user's current location
  void _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  // Fetch parking locations
  void fetchParkingLocations() async {
    setState(() {
      isLoading = true;
    });

    String apiUrl = 'https://parkkingzapi.crestclimbers.com/graphql/';
    String query = '''
      {
        parkinglocationsByFilter {
          locationName
          address
          cityId
          latitude
          longitude
          locationId
          parkinglots {
      availableSlots
      createdAt
      latitude
      locationId
      longitude
      lottypeImage
      lotTypId
      maxCapacity
      minCapacity
      parkinglotId
      parkingLotType
      updatedAt
      vehicleTypeId
      vendorId
    }
        }
      }
    ''';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['errors'] != null) {
          print("API Error: ${jsonResponse['errors']}");
        } else {
          processParkingData(jsonResponse);
        }
      } else {
        print("Failed to load data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Process parking data
  void processParkingData(Map<String, dynamic> json) {
    if (json.isEmpty || json['data'] == null) {
      print("No parking data available.");
      return;
    }

    try {
      List<dynamic> locations = json['data']['parkinglocationsByFilter'] ?? [];

      if (locations.isEmpty) {
        print("No parking locations found.");
        return;
      }

      List<ParkingLocation> fetchedLocations = locations
          .map((location) => ParkingLocation.fromJson(location))
          .toList();

      setState(() {
        parkingLocations = fetchedLocations;
        _addMarkers();
      });
    } catch (e) {
      print("Error processing parking data: $e");
    }
  }

  // Add markers to the map
  void _addMarkers() {
    markers.clear();
    for (var location in parkingLocations) {
      double lat = location.latitude ?? 0.0;
      double lng = location.longitude ?? 0.0;

      markers.add(
        Marker(
          markerId: MarkerId(location.locationId.toString()),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            location == selectedLocation
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueBlue,
          ),
          infoWindow: InfoWindow(
            title: location.locationName ?? "Unknown",
          ),
        ),
      );
    }
  }

  // Update map for a selected location
  void _updateMapForLocation(ParkingLocation selectedLocation) {
    double selectedLat = selectedLocation.latitude ?? 0.0;
    double selectedLng = selectedLocation.longitude ?? 0.0;

    setState(() {
      this.selectedLocation = selectedLocation;
      _addMarkers();
    });

    // Filter nearby locations within 10km using _calculateDistance
    List<ParkingLocation> nearbyLocations = parkingLocations.where((location) {
      double lat = location.latitude ?? 0.0;
      double lng = location.longitude ?? 0.0;

      double distance = _calculateDistance(
        selectedLat,
        selectedLng,
        lat,
        lng,
      );
      return distance <= 10; // 10 km radius
    }).toList();

    // Add markers for nearby locations
    for (var location in nearbyLocations) {
      double lat = location.latitude ?? 0.0;
      double lng = location.longitude ?? 0.0;

      markers.add(
        Marker(
          markerId: MarkerId(location.locationId.toString()),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            location == selectedLocation
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueBlue,
          ),
          infoWindow: InfoWindow(
            title: location.locationName ?? "Unknown",
          ),
        ),
      );
    }

    // Animate camera to the selected location
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(selectedLat, selectedLng),
        12, // Adjust zoom level as needed
      ),
    );
  }

  // Calculate distance between two coordinates
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the earth in km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  // Convert degrees to radians
  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  // Sort parking locations by distance from the user's current location
  List<ParkingLocation> _sortParkingLocationsByDistance() {
    if (currentLocation == null) return parkingLocations;

    return parkingLocations
      ..sort((a, b) {
        double distanceA = _calculateDistance(
          currentLocation!.latitude,
          currentLocation!.longitude,
          a.latitude ?? 0.0,
          a.longitude ?? 0.0,
        );
        double distanceB = _calculateDistance(
          currentLocation!.latitude,
          currentLocation!.longitude,
          b.latitude ?? 0.0,
          b.longitude ?? 0.0,
        );
        return distanceA.compareTo(distanceB);
      });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ParkingLocation> sortedLocations = _sortParkingLocationsByDistance();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isScrolled ? Colors.white : Colors.white,
        elevation: _isScrolled ? 4 : 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/hk.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    children: [
                      Icon(Icons.account_circle, size: 40),
                      SizedBox(width: 8),
                      Text('Hi, Welcome 👋'),
                      Spacer(),
                      Icon(Icons.local_activity,
                          size: 15, color: Colors.blue[900]),
                      Text(
                        ' Ticket',
                        style: TextStyle(color: Colors.blue[900], fontSize: 15),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchArea()),
                    );
                  },
                  child: AbsorbPointer(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search best parking',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: Icon(Icons.mic),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Recent Places Section (Horizontal Scroll)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Places',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          //  Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //        builder: (context) => SearchArea()),
                          //    );
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(color: Colors.blue[900]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: sortedLocations.map((location) {
                      return _recentPlaceTile(
                        location.locationName ?? 'Unknown',
                        // location.address ??
                        '',
                        Icons.train,
                        onTap: () => _updateMapForLocation(location),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
                // Nearest Parking Places Section (Vertical Scroll)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nearest Parking Places',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: (showAllNearestPlaces
                          ? sortedLocations
                          : sortedLocations.take(4))
                      .map((location) {
                    return _parkingPlaceTile(
                      location.locationName ?? 'Unknown',
                      location.address ?? 'Unknown',
                      '${location.parkingLots ?? 100} Slots',
                      onTap: () => _updateMapForLocation(location),
                    );
                  }).toList(),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        showAllNearestPlaces = !showAllNearestPlaces;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(33, 150, 243, 1.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text('View All'),
                  ),
                ),

                SizedBox(height: 16),
                // Google Map Section
                Container(
                  height: 300, // Adjust height as needed
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation ??
                          LatLng(0, 0), // Default to (0, 0) if location is null
                      zoom: 14,
                    ),
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Recent Place Tile
  Widget _recentPlaceTile(String place, String type, IconData icon,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          avatar: Icon(icon, color: Colors.blue, size: 30),
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(place, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(type, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Parking Place Tile
  Widget _parkingPlaceTile(String location, String type, String slots,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(Icons.local_parking, color: Colors.blue, size: 30),
        title: Text(location),
        subtitle: Text(type),
        trailing: Text(slots, style: TextStyle(color: Colors.blue)),
      ),
    );
  }
}

// ParkingLocation Model
class ParkingLocation {
  final String? locationName;
  final String? address;
  final int? cityId;
  final double? latitude;
  final double? longitude;
  final int? locationId;
  List<ParkingLot>? parkingLots;

  ParkingLocation({
    this.locationName,
    this.address,
    this.cityId,
    this.latitude,
    this.longitude,
    this.locationId,
    this.parkingLots,
  });

  factory ParkingLocation.fromJson(Map<String, dynamic> json) {
    return ParkingLocation(
        locationName: json['locationName'],
        address: json['address'],
        cityId: json['cityId'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        locationId: json['locationId'],
        parkingLots: json['parkingLots']);
  }
}
