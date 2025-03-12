import 'package:flutter/material.dart';
import 'package:par/model/parking_local.dart';

class TicketDetails extends StatelessWidget {
  final ParkingLotss parkingLot;
  final int availableSlots;

  const TicketDetails({
    Key? key,
    required this.parkingLot,
    required this.availableSlots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              parkingLot.locationName!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Address: ${parkingLot.address}'),
            Text('Available Slots: $availableSlots'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed to booking or other actions
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
