import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/cls/gsv.dart';
import 'package:par/cls/lgg.dart';
import 'package:par/model/vechiclesearch.dart';
import 'package:par/register/rguser.dart';

class GraphQLService {
  final GraphQLClient client;

  GraphQLService(this.client);

  // Register or login user using phone number
  Future<QueryResult> registerOrLoginUser(String phoneNumber) async {
    const String mutation = r'''
      mutation RegisterOrLoginUser($phoneNumber: String!) {
        registerOrLoginUser(phoneNumber: $phoneNumber) {
          message
          success
          data {
            otpCode
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'phoneNumber': phoneNumber,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data != null) {
        final bool success = result.data!['registerOrLoginUser']['success'];
        if (!success) {
          throw Exception(result.data!['registerOrLoginUser']['message']);
        }
      } else {
        throw Exception("No data received from the server.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to register or login: ${e.toString()}");
    }
  }

  // Verify OTP code for a given phone number
  Future<QueryResult> verifyWebOtp(String otpCode, String phoneNumber) async {
    const String mutation = r'''
      mutation VerifyWebOtp($otpCode: String!, $phoneNumber: String!) {
        verifyWebOtp(input: { otpCode: $otpCode, phoneNumber: $phoneNumber }) {
          message
          success
          data {
            isVerified
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'otpCode': otpCode,
        'phoneNumber': phoneNumber,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data != null) {
        final bool success = result.data!['verifyWebOtp']['success'];
        if (!success) {
          throw Exception(result.data!['verifyWebOtp']['message']);
        }
      } else {
        throw Exception("No data received from the server.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to verify OTP: ${e.toString()}");
    }
  } // Register a new vehicle

  Future<QueryResult> registerNewVehicle({
    required int userid,
    required String firstname,
    required String lastname,
    required String phonenumber,
    required String vehiclenumber,
  }) async {
    const String mutation = r'''
mutation RegisterNewVehicle(
  $userid: Int!,
  $firstname: String!,
  $lastname: String!,
  $phonenumber: String!,
  $vehiclenumber: String!) {
  registerNewVehicle(
    userid: $userid,
    firstname: $firstname,
    lastname: $lastname,
    phonenumber: $phonenumber,
    vehiclenumber: $vehiclenumber) {
    message
    success
    data {
      userid
      firstname
      lastname
      phonenumber
      vehiclenumber
    }
  }
}
''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'userid': userid,
        'firstname': firstname,
        'lastname': lastname,
        'phonenumber': phonenumber,
        'vehiclenumber': vehiclenumber,
      },
      operationName: 'RegisterNewVehicle',
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final response = result.data?['registerNewVehicle'];
      if (response == null || response['success'] == false) {
        throw Exception(response?['message'] ?? "Failed to register vehicle.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to register vehicle: ${e.toString()}");
    }
  }

  Future<Vehicle> fetchVehicleData() async {
    const String query = """
      query GetVehicles {
        vehicles {
          vehicleId
          makeModel
          vehicleNumber
          color
          isActive
          isRegistered
          registrationDate
          userId
          vehicleTypeId
          year
          createdAt
          updatedAt
        }
      }
    """;

    final QueryResult result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(
          "Error fetching vehicles: ${result.exception.toString()}");
    }

    return Vehicle.fromJson(result.data ?? {});
  }

  // Create a new booking

  Future<QueryResult> createBooking(
      int userId, int parkingSlotId, int? vehicleId) async {
    const String mutation = r'''
      mutation CreateBooking($userId: Int!, $parkingSlotId: Int!, $vehicleId: Int) {
        createBooking(userid: $userId, parkingslotid: $parkingSlotId, vehicleid: $vehicleId) {
          success
          message
          data {
            bookingDate
            bookingId
            bookingStatus
            inDate
            outDate
            totalHours
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        "userId": userId,
        "parkingSlotId": parkingSlotId,
        "vehicleId": vehicleId,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);
      return result; // This should work now
    } catch (e) {
      throw Exception("Failed to create booking: ${e.toString()}");
    } // Cancel a booking
  }

  Future<QueryResult> cancelBooking(int bookingId) async {
    const String mutation = r'''
      mutation CancelBooking($bookingId: Int!) {
        cancelBooking(bookingId: $bookingId) {
          message
          success
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'bookingId': bookingId,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      final bool success = result.data!['cancelBooking']['success'];
      if (!success) {
        throw Exception(result.data!['cancelBooking']['message']);
      }

      return result;
    } catch (e) {
      throw Exception("Failed to cancel booking: ${e.toString()}");
    }
  }

  // Create Booking Details
  Future<QueryResult> createBookingDetails({
    required int bookingDetailId,
    required int bookingId,
    required int charge,
    required String createdAt,
    required String description,
  }) async {
    const String mutation = r'''
      mutation CreateBookingDetails(
        $bookingDetailId: Int!,
        $bookingId: Int!,
        $charge: Int!,
        $createdAt: String!,
        $description: String!
      ) {
        createBookingDetails(input: {
          bookingDetailId: $bookingDetailId,
          bookingId: $bookingId,
          charge: $charge,
          createdAt: $createdAt,
          description: $description
        }) {
          message
          success
          data {
            bookingDetailId
            bookingId
            charge
            createdAt
            description
          }
        }
      }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'bookingDetailId': bookingDetailId,
        'bookingId': bookingId,
        'charge': charge,
        'createdAt': createdAt,
        'description': description,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data != null) {
        final bool success = result.data!['createBookingDetails']['success'];
        if (!success) {
          throw Exception(result.data!['createBookingDetails']['message']);
        }
      } else {
        throw Exception("No data received from the server.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to create booking details: ${e.toString()}");
    }
  }

  // Fetch Booking Details
  Future<QueryResult> fetchBookingDetails(int bookingDetailId) async {
    const String query = r'''
      query FetchBookingDetails($bookingDetailId: Int!) {
        fetchBookingDetails(bookingDetailId: $bookingDetailId) {
          message
          success
          data {
            bookingDetailId
            bookingId
            charge
            createdAt
            description
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {
        'bookingDetailId': bookingDetailId,
      },
    );

    try {
      final QueryResult result = await client.query(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data != null) {
        final bool success = result.data!['fetchBookingDetails']['success'];
        if (!success) {
          throw Exception(result.data!['fetchBookingDetails']['message']);
        }
      } else {
        throw Exception("No data received from the server.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to fetch booking details: ${e.toString()}");
    }
  }

  // Fetch parking slots
  Future<List<Parkinglotsvs>> fetchParkingSlots(int locationId) async {
    const String query = r'''
      query GetParkingSlots($locationId: Int!) {
        parkingSlots(locationId: $locationId) {
          parkinglotId
          availableSlots
          maxCapacity
          locationId
          latitude
          longitude
          lottypeImage
          lotTypId
          minCapacity
          parkingLotType
          createdAt
          updatedAt
          vehicleTypeId
          vendorId
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'locationId': locationId},
    );

    try {
      final QueryResult result = await client.query(options);

      final List<dynamic> slotsData = result.data?['parkingSlots'] ?? [];
      return slotsData.map((slot) => Parkinglotsvs.fromJson(slot)).toList();
    } catch (e) {
      throw Exception("Failed to fetch parking slots: ${e.toString()}");
    }
  }

  Future<QueryResult> createParkingLot({
    required int lottypeid,
    required int locationid,
    required int mincapacity,
    required int maxcapacity,
    required int vendorid,
  }) async {
    const String mutation = r'''
    mutation CreateParkingLot(
      $lottypeid: Int!,
      $locationid: Int!,
      $mincapacity: Int!,
      $maxcapacity: Int!,
      $vendorid: Int!
    ) {
      createParkingLot(
        lottypeid: $lottypeid,
        locationid: $locationid,
        mincapacity: $mincapacity,
        maxcapacity: $maxcapacity,
        vendorid: $vendorid
      ) {
        message
        success
        data {
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

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'lottypeid': lottypeid,
        'locationid': locationid,
        'mincapacity': mincapacity,
        'maxcapacity': maxcapacity,
        'vendorid': vendorid,
      },
    );

    try {
      final QueryResult result = await client.mutate(options);

      print("GraphQL Result: ${result.data}");
      print("GraphQL Errors: ${result.exception?.graphqlErrors}");

      if (result.hasException) {
        throw Exception("GraphQL Error: ${result.exception.toString()}");
      }

      return result;
    } catch (e) {
      print("Failed to create parking lot: $e");
      throw Exception("Failed to create parking lot: ${e.toString()}");
    }
  }

  Future<QueryResult> createLotType({
    required String message,
    required bool success,
    required int lotTypeId,
    required String lottypeurl,
    required String parkingLotType,
  }) async {
    const String mutation = r'''
mutation CreateLotType(
  $message: String!,
  $success: Boolean!,
  $lotTypeId: Int!,
  $lottypeurl: String!,
  $parkingLotType: String!) {
  createLotType(
    message: $message,
    success: $success,
    lotTypeId: $lotTypeId,
    lottypeurl: $lottypeurl,
    parkingLotType: $parkingLotType) {
    message
    success
    data {
      lotTypeId
      lottypeurl
      parkingLotType
    }
  }
}
''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'message': message,
        'success': success,
        'lotTypeId': lotTypeId,
        'lottypeurl': lottypeurl,
        'parkingLotType': parkingLotType,
      },
      operationName: 'CreateLotType',
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final response = result.data?['createLotType'];
      if (response == null || response['success'] == false) {
        throw Exception(response?['message'] ?? "Failed to create lot type.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to create lot type: ${e.toString()}");
    }
  }

  // Fetch lot type data
  Future<LotTypeData> fetchLotTypeData() async {
    const String query = """
      query GetLotTypes {
        lotTypes {
          lotTypeId
          lottypeurl
          parkingLotType
        }
      }
    """;

    final QueryResult result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(
          "Error fetching lot types: ${result.exception.toString()}");
    }

    return LotTypeData.fromJson(result.data ?? {});
  }

  Future<QueryResult> createParkingSlot({
    required int parkinglotId,
    required String slotNumber, // Matches API response
  }) async {
    const String mutation = r'''
    mutation CreateParkingSlot(
      $parkinglotid: Int!,
      $slotNumber: String!
    ) {
      createSlot(
        parkinglotid: $parkinglotid,
        slotNumber: $slotNumber  # Fixed typo (was slotumber)
      ) {
        message
        success
        data {
          slotId
          parkinglotId
          slotNumber
          slotStatus
          isOccupied
          createdAt
          updatedAt
        }
      }
    }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'parkinglotid': parkinglotId,
        'slotNumber': slotNumber, // Corrected variable name
      },
      operationName: 'CreateParkingSlot',
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final response = result.data?['createSlot'];
      if (response == null || response['success'] == false) {
        throw Exception(
            response?['message'] ?? "Failed to create parking slot.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to create parking slot: ${e.toString()}");
    }
  }

  Future<RegisterData> fetchUserData() async {
    const String query = """
      query GetUser {
        user {
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

    final QueryResult result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(
          "Error fetching user data: ${result.exception.toString()}");
    }

    return RegisterData.fromJson(result.data ?? {});
  }

  Future<QueryResult> getSlotsByParkingLotId(int parkingLotId) async {
    const String query = r'''
      query GetSlotsByParkingLotId($parkingLotId: Int!) {
        slotsByParkingLotId(parkingLotId: $parkingLotId) {
          message
          success
          data {
            createdAt
            isOccupied
            parkinglotId
            slotId
            slotNumber
            slotStatus
            updatedAt
          }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'parkingLotId': parkingLotId},
    );

    return await client.query(options);
  }

  // Register a new user
  Future<QueryResult> registerNewUser({
    required int userId,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    const String mutation = r'''
mutation RegisterNewUser(
  $userId: Int!,
  $firstName: String!,
  $lastName: String!,
  $phoneNumber: String!,
  $email: String!) {
  registerNewUser(
    userId: $userId,
    firstName: $firstName,
    lastName: $lastName,
    phoneNumber: $phoneNumber,
    email: $email) {
    message
    success
    data {
      userId
      firstName
      lastName
      phoneNumber
      email
    }
  }
}
''';

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': email,
      },
      operationName: 'RegisterNewUser',
    );

    try {
      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final response = result.data?['registerNewUser'];
      if (response == null || response['success'] == false) {
        throw Exception(response?['message'] ?? "Failed to register user.");
      }

      return result;
    } catch (e) {
      throw Exception("Failed to register user: ${e.toString()}");
    }
  }
}
