import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/model/parking_local.dart';
import 'package:par/model/vechicle_contro.dart';
import 'package:par/model/vechiclesearch.dart';
import 'package:par/server/login_back.dart';
import 'package:par/slots/ticket_view.dart';
import 'package:par/vechicles/vechicles_add.dart';

class VehicleDetails extends StatefulWidget {
  final GraphQLService graphQLService;
  final ParkingLotss parkingLot;
  final String selectedSlot; // Add selectedSlot parameter

  const VehicleDetails({
    super.key,
    required this.graphQLService,
    required this.parkingLot,
    required this.selectedSlot, // Initialize selectedSlot
  });

  @override
  _VehicleDetailsState createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final VehicleController vehicleController = Get.put(VehicleController(
    GraphQLClient(
      link: HttpLink('https://parkkingzapi.crestclimbers.com/graphql/'),
      cache: GraphQLCache(),
    ),
  ));

  bool _showAllVehicles = false;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    vehicleController.fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Vehicle Details'),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (vehicleController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (vehicleController.errorMessage.value.isNotEmpty) {
            return Center(child: Text(vehicleController.errorMessage.value));
          } else if (vehicleController.vehicles.isEmpty) {
            return const Center(child: Text("No vehicles available."));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Vehicle Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _showAllVehicles
                        ? vehicleController.vehicles.length
                        : (vehicleController.vehicles.length > 4
                            ? 4
                            : vehicleController.vehicles.length),
                    itemBuilder: (context, index) {
                      final vehicle = vehicleController.vehicles[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: _selectedIndex,
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedIndex = value ?? -1;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                vehicle.makeModel ?? 'Unknown ',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              vehicle.vehicleNumber ?? 'Unknown Number',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (vehicleController.vehicles.length > 4)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllVehicles = !_showAllVehicles;
                        });
                      },
                      child: Text(
                        _showAllVehicles ? 'Show Less' : 'View All',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehiclesAddScreen(
                            graphQLService: widget.graphQLService,
                          ),
                        ),
                      );

                      if (result != null && result is Vehicle) {
                        vehicleController.vehicles.add(result);
                      }
                    },
                    child: const Text(
                      '+ Add Vehicle',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (_selectedIndex == null) {
                        // Show SnackBar at the top
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please select a vehicle.'),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height - 100,
                              left: 10,
                              right: 10,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParkingTic(
                            parkingLot: widget.parkingLot,
                            selectedSlot: widget
                                .selectedSlot, // Pass the correct slot number
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Book Now',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
