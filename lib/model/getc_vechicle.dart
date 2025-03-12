import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/model/vechicle_contro.dart';
// Import your controller

class VehicleListScreen extends StatelessWidget {
  // Initialize GraphQLClient
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
        'https://parkkingzapi.crestclimbers.com/graphql/'); // Your GraphQL API endpoint

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    // Pass the client to the VehicleController
    final VehicleController controller = Get.put(VehicleController(client));

    return Scaffold(
      appBar: AppBar(title: Text("Vehicle List")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: controller.fetchVehicles, // Trigger vehicle fetching
            child: Text("Fetch Vehicles"),
          ),
          Expanded(
            child: Obx(() {
              // Show loading indicator while fetching data
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              // Display any error messages
              if (controller.errorMessage.value.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }
              // If there are no vehicles available
              if (controller.vehicles.isEmpty) {
                return Center(child: Text("No vehicles available"));
              }
              // Display the list of vehicles
              return ListView.builder(
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  var vehicle = controller.vehicles[index];
                  return ListTile(
                    title: Text(vehicle.makeModel ?? "Unknown Vehicle"),
                    subtitle: Text(
                        "Vehicle Number: ${vehicle.vehicleNumber ?? "N/A"}"),
                    trailing: Text("Color: ${vehicle.color ?? "N/A"}"),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
