import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/model/parking_local.dart';
import 'package:par/model/parv_ne.dart';
import 'package:par/server/login_back.dart';
import 'package:par/vechicles/vechices_details.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class ParkingScreen extends StatefulWidget {
  final ParkingLotss parkingLot;

  const ParkingScreen({super.key, required this.parkingLot});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  static const int rows = 10;
  static const int cols = 10;
  static const int available = 0;
  static const int booked = 1;
  static const int processing = 2;

  List<List<int>> gridStatus =
      List.generate(rows, (i) => List.filled(cols, available));
  int? selectedSlot;
  Set<int> processingSlots = {};
  double? distanceFromUser;

  final GraphQLService graphQLService = GraphQLService(
    GraphQLClient(
      link: HttpLink('https://parkkingzapi.crestclimbers.com/graphql/'),
      cache: GraphQLCache(),
    ),
  );

  @override
  void initState() {
    super.initState();
    _createParkingLot();
    _fetchParkingSlotDetails();
    _getUserLocationAndCalculateDistance();
  }

  Future<void> _getUserLocationAndCalculateDistance() async {
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

    double userLat = position.latitude;
    double userLng = position.longitude;
    double parkingLat = widget.parkingLot.latitude ?? 0.0;
    double parkingLng = widget.parkingLot.longitude ?? 0.0;

    if (parkingLat == 0.0 || parkingLng == 0.0) {
      print("Invalid parking lot coordinates.");
      return;
    }

    double distance =
        _calculateDistance(userLat, userLng, parkingLat, parkingLng);

    // Subtract the incorrect value (13932.600) if it exists
    if (distance > 13930) {
      distance -= 13932.600;
    }

    setState(() {
      distanceFromUser = distance;
    });
  }

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

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  Future<void> _createParkingLot() async {
    try {
      final result = await graphQLService.createParkingLot(
        lottypeid: 1,
        locationid: 1,
        mincapacity: 2,
        maxcapacity: 12,
        vendorid: 1,
      );

      if (result.data != null) {
        final lotData = result.data!['createParkingLot']['data'];
        print("Parking Lot Created: $lotData");
      }
    } catch (e) {
      _showSnackBar('Failed to create parking lot: ${e.toString()}');
    }
  }

  Future<void> _fetchParkingSlotDetails() async {
    try {
      final result = await graphQLService
          .getSlotsByParkingLotId(widget.parkingLot.locationId!);

      if (result.data != null) {
        final Parss parss = Parss.fromJson(result.data!);
        if (parss.data?.slotsByParkingLotId?.data != null) {
          for (var slot in parss.data!.slotsByParkingLotId!.data!) {
            int slotNumber = int.parse(slot.slotNumber!.substring(1));
            int row = (slotNumber - 101) ~/ cols;
            int col = (slotNumber - 101) % cols;
            gridStatus[row][col] = slot.isOccupied! ? booked : available;
          }
          setState(() {});
        }
      }
    } catch (e) {
      _showSnackBar('Failed to fetch parking slot details: ${e.toString()}');
    }
  }

  Future<void> bookSlot() async {
    if (selectedSlot == null) {
      _showSnackBar('Please select a slot before booking.');
      return;
    }

    int row = selectedSlot! ~/ cols;
    int col = selectedSlot! % cols;

    if (gridStatus[row][col] == booked) {
      _showSnackBar('This slot is already booked.');
      return;
    }

    int parkingSlotId = (row * cols) + col + 101; // Correct slot number logic
    int userId = 254;
    int? vehicleId;

    try {
      final result =
          await graphQLService.createBooking(userId, parkingSlotId, vehicleId);

      if (result.data != null && result.data!['createBooking']['success']) {
        setState(() {
          gridStatus[row][col] = booked;
          processingSlots.remove(selectedSlot!);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleDetails(
              graphQLService: graphQLService,
              parkingLot: widget.parkingLot,
              selectedSlot:
                  'A${parkingSlotId.toString().padLeft(4, '0')}', // Pass correct slot number
            ),
          ),
        );
      } else {
        _showSnackBar(
            'Booking failed: ${result.data?['createBooking']['message'] ?? "Unknown error"}');
      }
    } catch (e) {
      _showSnackBar('Failed to book slot: ${e.toString()}');
    }
  }

  void onSlotSelected(int index) {
    int row = index ~/ cols;
    int col = index % cols;

    if (gridStatus[row][col] == available) {
      setState(() {
        selectedSlot = index;
        gridStatus[row][col] = processing;
        processingSlots.add(index);
      });
    } else if (gridStatus[row][col] == processing) {
      setState(() {
        selectedSlot = index;
      });
    } else {
      _showSnackBar('This slot is already booked.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 110,
          left: 10,
          right: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on),
            const SizedBox(width: 8),
            Text(widget.parkingLot.locationName!,
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.train,
                color: Colors.black,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.parkingLot.locationName!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    if (distanceFromUser != null)
                      Text(
                        '${_formatDistance(distanceFromUser!)} from you',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${widget.parkingLot.parkingLots} Slots',
                      style: const TextStyle(fontSize: 18, color: Colors.blue)),
                  const Text('Available',
                      style: TextStyle(fontSize: 16, color: Colors.blue)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 10),
          _buildLegend(),
          Expanded(child: _buildGrid()),
          if (selectedSlot != null) _buildBookingSection(),
        ],
      ),
    );
  }

  String _formatDistance(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).toStringAsFixed(0)} meters';
    } else {
      return '${distance.toStringAsFixed(1)} km';
    }
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(Colors.red, "Booked"),
          const SizedBox(width: 10),
          _buildLegendItem(Colors.yellow, "Processing"),
          const SizedBox(width: 10),
          _buildLegendItem(
              const Color.fromARGB(255, 216, 205, 205), "Available"),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: rows * cols,
      itemBuilder: (context, index) {
        int row = index ~/ cols;
        int col = index % cols;
        Color color;

        switch (gridStatus[row][col]) {
          case booked:
            color = Colors.red;
            break;
          case processing:
            color = Colors.yellow;
            break;
          default:
            color = const Color.fromARGB(255, 216, 205, 205);
        }

        return GestureDetector(
          onTap: () => onSlotSelected(index),
          child: Container(
            decoration: BoxDecoration(
              color: selectedSlot == index ? Colors.blue : color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Booking Slot No",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                "A${(selectedSlot! + 1).toString().padLeft(4, '0')}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: bookSlot,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  const Color(0xFF2196F3), // Hex color for consistency
              shadowColor: const Color(0xFF2196F3),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: const Text(
              "Book Now",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
