import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:par/model/parking_local.dart';
import 'package:par/slots/tictic.dart';

class ParkingTic extends StatelessWidget {
  final ParkingLotss parkingLot;
  final String selectedSlot;

  const ParkingTic({
    Key? key,
    required this.parkingLot,
    required this.selectedSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LastTicketCard(parkingLot: parkingLot, selectedSlot: selectedSlot),
            const Divider(),
            TicketHistory(parkingLot: parkingLot),
          ],
        ),
      ),
    );
  }
}

class LastTicketCard extends StatefulWidget {
  final ParkingLotss parkingLot;
  final String selectedSlot;

  const LastTicketCard({
    Key? key,
    required this.parkingLot,
    required this.selectedSlot,
  }) : super(key: key);

  @override
  _LastTicketCardState createState() => _LastTicketCardState();
}

class _LastTicketCardState extends State<LastTicketCard> {
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _timeFormat = DateFormat('hh:mm a');
  int _totalHours = 1; // Default to 1 hour
  final double _ratePerHour = 5.0; // ₹5 per hour

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(9600, 12, 31),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _incrementHours() {
    setState(() {
      _totalHours++;
    });
  }

  void _decrementHours() {
    if (_totalHours > 1) {
      setState(() {
        _totalHours--;
      });
    }
  }

  double _calculateTotalAmount() {
    return _totalHours * _ratePerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/image1.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.parkingLot.locationName ?? 'Unknown Location',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.parkingLot.address ?? 'Unknown Address'),
                    const SizedBox(height: 8),
                    const Text('Slot No.'),
                    Text(
                      (int.tryParse(RegExp(r'\d+')
                                      .stringMatch(widget.selectedSlot) ??
                                  '0')! -
                              100)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        children: const [
                          Icon(Icons.access_time, size: 16),
                          SizedBox(width: 4),
                          Text('In time'),
                        ],
                      ),
                    ),
                    Text(
                      _selectedDate != null
                          ? '${_dateFormat.format(_selectedDate!)} \n ${_timeFormat.format(_selectedDate!)}'
                          : 'Select Date and Time',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Hours'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementHours,
                    ),
                    Text('$_totalHours hours'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementHours,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount'),
                Text(
                  '₹ ${_calculateTotalAmount().toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Pay Now button is always visible
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle payment logic here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketHistory extends StatelessWidget {
  final ParkingLotss parkingLot;

  const TicketHistory({Key? key, required this.parkingLot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*   Text(
                parkingLot.locationName ?? 'Unknown Location',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ), */
              const SizedBox(height: 8),
              const Text(
                'Ticket History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        // Example of a past ticket
        ListTile(
          title: Text(
            parkingLot.locationName ?? 'Unknown Location',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // subtitle: const Text('Date: 01-01-2023'),
          trailing: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicPage(
                      // Pass correct slot number
                      ),
                ),
              );
            },
            child: const Text('View Ticket'),
          ),
        ),
        // Example of a future ticket
        /*  ListTile(
          title: const Text('Ticket 2'),
          subtitle: const Text('Date: 02-01-2023'),
          trailing: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicPage(
                      // Pass correct slot number
                      ),
                ),
              );
            },
            //  child: const Text('View Ticket'),
          ),
        ), */
        // Add more tickets dynamically here
      ],
    );
  }
}
