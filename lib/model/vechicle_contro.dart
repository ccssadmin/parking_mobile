//CONTROLLER
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/model/vechiclesearch.dart';
// Your vehicle model

class VehicleController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = "".obs;
  var vehicles = <Vehicle>[].obs; // List to store vehicles

  final GraphQLClient _client;

  // Constructor accepting GraphQLClient
  VehicleController(this._client);

  // Fetch vehicles from the GraphQL API
  Future<void> fetchVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Example GraphQL query for vehicles (update with your query)
      const String vehicleQuery = """
      query {
        vehicles {
          vehicleNumber
          makeModel
          color
        }user {
      aadhaarNumber
      createdAt
      email
      firstName
      isActive
      isKycVerified
      isMobileVerified
      lastName
      password
      passwordHash
      phoneNumber
      profileUrl
      updatedAt
      userId
      vehicleId
    }
      }
      """;

      // Execute the query
      final QueryResult result = await _client.query(
        QueryOptions(document: gql(vehicleQuery)),
      );

      if (result.hasException) {
        errorMessage.value =
            'Error fetching data: ${result.exception.toString()}';
        return;
      }

      if (result.data == null || result.data!['vehicles'] == null) {
        errorMessage.value = 'No vehicle data found.';
        return;
      }

      // Parsing vehicle data from the query result
      var vehiclesData = result.data!['vehicles'] as List;
      vehicles.value = vehiclesData
          .map((vehicle) => Vehicle.fromJson(
              vehicle)) // Assuming a Vehicle model with a fromJson method
          .toList();
    } catch (e) {
      errorMessage.value = 'Failed to load vehicles: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
