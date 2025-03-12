class ParkingSearch {
  Data? data;

  ParkingSearch({this.data});

  factory ParkingSearch.fromJson(Map<String, dynamic> json) {
    return ParkingSearch(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<ParkingLocation>? parkingLocationsByFilter;

  Data({this.parkingLocationsByFilter});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      parkingLocationsByFilter: (json['parkingLocationsByFilter'] as List?)
          ?.map((v) => ParkingLocation.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parkingLocationsByFilter':
          parkingLocationsByFilter?.map((v) => v.toJson()).toList(),
    };
  }
}

class ParkingLocation {
  String? address;
  int? cityId;
  double? latitude;
  int? locationId;
  String? locationName;
  double? longitude;
  List<ParkingLot>? parkingLots;

  ParkingLocation({
    this.address,
    this.cityId,
    this.latitude,
    this.locationId,
    this.locationName,
    this.longitude,
    this.parkingLots,
  });

  factory ParkingLocation.fromJson(Map<String, dynamic> json) {
    return ParkingLocation(
      address: json['address'],
      cityId: json['cityId'],
      latitude: json['latitude'].toDouble(),
      locationId: json['locationId'],
      locationName: json['locationName'],
      longitude: json['longitude'].toDouble(),
      parkingLots: (json['parkingLots'] as List?)
          ?.map((v) => ParkingLot.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'cityId': cityId,
      'latitude': latitude,
      'locationId': locationId,
      'locationName': locationName,
      'longitude': longitude,
      'parkingLots': parkingLots?.map((v) => v.toJson()).toList(),
    };
  }
}

class ParkingLot {
  int? availableSlots;

  ParkingLot({this.availableSlots});

  factory ParkingLot.fromJson(Map<String, dynamic> json) {
    return ParkingLot(
      availableSlots: json['availableSlots'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableSlots': availableSlots,
    };
  }
}

void processParkingLocation(Map<String, dynamic> jsonData) {
  ParkingSearch parkingSearch = ParkingSearch.fromJson(jsonData);

  if (parkingSearch.data != null &&
      parkingSearch.data!.parkingLocationsByFilter!.isNotEmpty) {
    for (var location in parkingSearch.data!.parkingLocationsByFilter!) {
      print("Location Name: ${location.locationName}");
      print("Address: ${location.address}");
      print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");
      if (location.parkingLots != null && location.parkingLots!.isNotEmpty) {
        print("Parking Lots:");
        for (var lot in location.parkingLots!) {
          print("  - Available Slots: ${lot.availableSlots}");
        }
      } else {
        print("No parking lots available.");
      }
      print("----------------------------");
    }
  } else {
    print("No parking locations found.");
  }
}
