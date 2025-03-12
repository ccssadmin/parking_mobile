import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:par/model/vechiclesearch.dart';
import 'package:par/server/login_back.dart';

class VehiclesAddScreen extends StatefulWidget {
  final GraphQLService graphQLService;
  VehiclesAddScreen({required this.graphQLService});

  @override
  _VehiclesAddScreenState createState() => _VehiclesAddScreenState();
}

class _VehiclesAddScreenState extends State<VehiclesAddScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController vehicleNoController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();

  void _addVehicle() async {
    String userIdText = userIdController.text.trim();
    if (userIdText.isEmpty) {
      _showTopSnackBar('User ID cannot be empty');
      return;
    }

    int? userId = int.tryParse(userIdText);
    if (userId == null) {
      _showTopSnackBar('User ID must be a number');
      return;
    }

    String phoneNumber = phoneNoController.text.trim();
    if (phoneNumber.isEmpty) {
      _showTopSnackBar('Phone number cannot be empty');
      return;
    }

    if (phoneNumber.length != 10) {
      _showTopSnackBar('Phone number must be exactly 10 digits');
      return;
    }

    try {
      await widget.graphQLService.registerNewVehicle(
        userid: userId,
        firstname: firstNameController.text.trim(),
        lastname: lastNameController.text.trim(),
        phonenumber: phoneNumber,
        vehiclenumber: vehicleNoController.text.trim(),
      );

      // Create a new vehicle object with entered values
      Vehicle newVehicle = Vehicle(
        userId: userId,
        makeModel: "${firstNameController.text} ${lastNameController.text}",
        vehicleNumber: vehicleNoController.text,
      );

      _showTopSnackBar('Vehicle added successfully!');

      Navigator.of(context).pop(newVehicle); // Pass the new vehicle back
    } catch (e) {
      _showTopSnackBar('Failed to add vehicle: $e');
    }
  }

  // Helper method to show SnackBar at the top of the screen
  void _showTopSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: message.contains('Failed') ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating, // Makes the SnackBar float
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 110, // Position at the top
        left: 10,
        right: 10,
      ),
      duration: const Duration(seconds: 3),
    ) // Adjust duration as needed
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Vehicle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Text(
                'Add New Vehicle',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 3.5,
              shrinkWrap: true,
              children: [
                TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User ID',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
                  ),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last Name',
                  ),
                ),
                TextField(
                  controller: vehicleNoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle No',
                  ),
                ),
                TextField(
                  controller: phoneNoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone No',
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        10), // Restrict to 10 digits
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: _addVehicle,
                  child: const Text(
                    'Add Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
