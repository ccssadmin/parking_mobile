import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:par/model/parking_local.dart';
import 'package:par/model/search_query.dart';
import 'dart:convert';
import 'package:par/tickets/ticket_details.dart';
import 'package:geolocator/geolocator.dart'; // For location services
import 'dart:math'; // For distance calculation
import 'package:speech_to_text/speech_to_text.dart'
    as stt; // For speech-to-text

class SearchArea extends StatefulWidget {
  const SearchArea({super.key});

  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  List<ParkingLocation> parkingLocations = [];
  bool isLoading = false;
  String searchQuery = '';
  LatLng? currentLocation; // Store user's current location
  bool showAll = false; // State to control whether to show all items or not
  final FocusNode _focusNode = FocusNode(); // Focus node for the TextField
  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Speech-to-text instance
  bool _isListening = false; // Track if speech recognition is active

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch user's current location
    fetchParkingLocations();
    _focusNode.requestFocus(); // Request focus for the TextField
    _initializeSpeech(); // Initialize speech recognition
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  // Initialize speech recognition
  void _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (available) {
      print("Speech recognition initialized");
    } else {
      print("Speech recognition not available");
    }
  }

  // Start listening for speech input
  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              searchQuery = result.recognizedWords;
              filterParkingLocations(searchQuery);
            });
          },
        );
      }
    }
  }

  // Stop listening for speech input
  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
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
      });
    } catch (e) {
      print("Error processing parking data: $e");
    }
  }

  // Filter parking locations based on search query
  void filterParkingLocations(String query) {
    setState(() {
      searchQuery = query;
    });
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

  // Get filtered and sorted parking locations
  List<ParkingLocation> get filteredParkingLocations {
    List<ParkingLocation> sortedLocations = _sortParkingLocationsByDistance();

    if (searchQuery.isEmpty) {
      return sortedLocations;
    } else {
      return sortedLocations.where((location) {
        return location.locationName!
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text('Parking Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              focusNode: _focusNode, // Assign the focus node
              decoration: InputDecoration(
                hintText: 'Search best parking',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: _isListening ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: filterParkingLocations,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (searchQuery.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Recent Searches',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      filteredParkingLocations.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text("No parking locations found"),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: showAll
                                    ? filteredParkingLocations.length
                                    : min(4, filteredParkingLocations.length),
                                itemBuilder: (context, index) {
                                  final location =
                                      filteredParkingLocations[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ParkingScreen(
                                            parkingLot: ParkingLotss(
                                              locationName:
                                                  location.locationName,
                                              address: location.address,
                                              latitude: location.latitude,
                                              longitude: location.longitude,
                                              locationId: location.locationId,
                                              parkingLots: location.parkingLots,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.location_on,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                          location.locationName ?? "Unknown"),
                                    ),
                                  );
                                },
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                showAll = !showAll;
                              });
                            },
                            child: Text(showAll ? 'Show Less' : 'See All'),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

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
