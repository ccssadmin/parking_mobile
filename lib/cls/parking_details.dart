import 'package:flutter/material.dart';
import 'package:par/cls/park.dart';

class ParkingDet extends StatelessWidget {
  final Parks parkingLotlov; // Renamed from Parkinglots to Park

  // Updated constructor to use Park instead of Parkinglots
  ParkingDet({required this.parkingLotlov});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parkingLotlov.name ?? 'Parking Details'),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking Lot Name
            Text(
              parkingLotlov.name ?? 'Unknown Parking Lot',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Available Slots
            Row(
              children: [
                Icon(Icons.local_parking, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Available Slots: ${parkingLotlov.availableSlots ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Location (Latitude and Longitude)
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Latitude: ${parkingLotlov.latitude ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Longitude: ${parkingLotlov.longitude ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Parking Lot Type
            Row(
              children: [
                Icon(Icons.category, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Type: ${parkingLotlov.parkingLotType ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Max and Min Capacity
            Row(
              children: [
                Icon(Icons.emoji_transportation, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Max Capacity: ${parkingLotlov.maxCapacity ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.emoji_transportation, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Min Capacity: ${parkingLotlov.minCapacity ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Additional Details
            Text(
              'Additional Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vehicle Type ID: ${parkingLotlov.vehicleTypeId ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Vendor ID: ${parkingLotlov.vendorId ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(), // Pushes the button to the bottom
            Container(
              width: double.infinity, // Makes the button full width
              padding: EdgeInsets.symmetric(vertical: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
