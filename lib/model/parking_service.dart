import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:par/homes/home_page.dart';

class ParkingService {
  static const String apiUrl =
      'https://parkkingzapi.crestclimbers.com/graphql/';

  Future<List<ParkingLocation>> fetchParkingLocations() async {
    String query = '''
      {
        parkinglocationsByFilter {
          locationName
          address
          cityId
          latitude
          longitude
          locationId
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['errors'] != null) {
        throw Exception("API Error: ${jsonResponse['errors']}");
      } else {
        List<dynamic> locations =
            jsonResponse['data']['parkinglocationsByFilter'] ?? [];
        return locations
            .map((location) => ParkingLocation.fromJson(location))
            .toList();
      }
    } else {
      throw Exception(
          "Failed to load data. Status Code: ${response.statusCode}");
    }
  }

  Future<void> bookParkingSlot() async {
    String mutation = '''
    mutation {
      createBooking(bookingInput: {
        bookingDate: "2025-02-20",
        bookingStatus: "CONFIRMED",
        parkingSlotId: 1,
        paymentStatus: "PAID",
        userId: 123,
        vehicleId: 456
      }) {
        bookingId
        bookingStatus
      }
    }
  ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": mutation}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("Booking Successful: ${jsonResponse['data']['createBooking']}");
    } else {
      throw Exception("Failed to book slot: ${response.statusCode}");
    }
  }

  Future<void> generateParkingTicket(int bookingId) async {
    String mutation = '''
    mutation {
      createParkingTicket(ticketInput: {
        bookingId: $bookingId,
        ticketStatus: "ACTIVE",
        ticketType: "HOURLY",
        totalHours: 2,
        ticketPrice: 50.0
      }) {
        ticketId
        ticketStatus
      }
    }
  ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": mutation}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("Ticket Generated: ${jsonResponse['data']['createParkingTicket']}");
    } else {
      throw Exception("Failed to generate ticket: ${response.statusCode}");
    }
  }

  Future<void> exitParking(int bookingId) async {
    String mutation = '''
    mutation {
      exitParking(bookingId: $bookingId) {
        bookingStatus
        paymentStatus
      }
    }
  ''';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": mutation}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("Exited Parking: ${jsonResponse['data']['exitParking']}");
    } else {
      throw Exception("Failed to exit: ${response.statusCode}");
    }
  }
}
