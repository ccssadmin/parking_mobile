class ParkingLocationl {
  final String? locationName;
  final String? address;
  final int? cityId;
  final double? latitude;
  final double? longitude;
  final int? locationId;

  ParkingLocationl({
    this.locationName,
    this.address,
    this.cityId,
    this.latitude,
    this.longitude,
    this.locationId,
  });

  factory ParkingLocationl.fromJson(Map<String, dynamic> json) {
    return ParkingLocationl(
      locationName: json['locationName'],
      address: json['address'],
      cityId: json['cityId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationId: json['locationId'],
    );
  }
}

class Parv {
  Data? data;

  Parv({this.data});

  factory Parv.fromJson(Map<String, dynamic> json) {
    return Parv(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class Data {
  List<ParkinglocationsByFilter>? parkinglocationsByFilter;

  Data({this.parkinglocationsByFilter});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      parkinglocationsByFilter: json['parkinglocationsByFilter'] != null
          ? (json['parkinglocationsByFilter'] as List)
              .map((v) => ParkinglocationsByFilter.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (parkinglocationsByFilter != null)
        'parkinglocationsByFilter':
            parkinglocationsByFilter!.map((v) => v.toJson()).toList(),
    };
  }
}

class ParkinglocationsByFilter {
  String? address;
  int? cityId;
  double? latitude;
  int? locationId;
  String? locationName;
  double? longitude;
  List<Parkinglotsvs>? parkinglots;

  ParkinglocationsByFilter({
    this.address,
    this.cityId,
    this.latitude,
    this.locationId,
    this.locationName,
    this.longitude,
    this.parkinglots,
  });

  factory ParkinglocationsByFilter.fromJson(Map<String, dynamic> json) {
    return ParkinglocationsByFilter(
      address: json['address'],
      cityId: json['cityId'],
      latitude: json['latitude']?.toDouble(),
      locationId: json['locationId'],
      locationName: json['locationName'],
      longitude: json['longitude']?.toDouble(),
      parkinglots: json['parkinglots'] != null
          ? (json['parkinglots'] as List)
              .map((v) => Parkinglotsvs.fromJson(v))
              .toList()
          : null,
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
      if (parkinglots != null)
        'parkinglots': parkinglots!.map((v) => v.toJson()).toList(),
    };
  }
}

class Parkinglotsvs {
  int? availableSlots;
  dynamic createdAt;
  String? latitude;
  int? locationId;
  String? longitude;
  String? lottypeImage;
  dynamic lotTypId;
  int? maxCapacity;
  int? minCapacity;
  int? parkinglotId;
  String? parkingLotType;
  dynamic updatedAt;
  dynamic vehicleTypeId;
  dynamic vendorId;

  Parkinglotsvs({
    this.availableSlots,
    this.createdAt,
    this.latitude,
    this.locationId,
    this.longitude,
    this.lottypeImage,
    this.lotTypId,
    this.maxCapacity,
    this.minCapacity,
    this.parkinglotId,
    this.parkingLotType,
    this.updatedAt,
    this.vehicleTypeId,
    this.vendorId,
  });

  factory Parkinglotsvs.fromJson(Map<String, dynamic> json) {
    return Parkinglotsvs(
      availableSlots: json['availableSlots'],
      createdAt: json['createdAt'],
      latitude: json['latitude'],
      locationId: json['locationId'],
      longitude: json['longitude'],
      lottypeImage: json['lottypeImage'],
      lotTypId: json['lotTypId'],
      maxCapacity: json['maxCapacity'],
      minCapacity: json['minCapacity'],
      parkinglotId: json['parkinglotId'],
      parkingLotType: json['parkingLotType'],
      updatedAt: json['updatedAt'],
      vehicleTypeId: json['vehicleTypeId'],
      vendorId: json['vendorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableSlots': availableSlots,
      'createdAt': createdAt,
      'latitude': latitude,
      'locationId': locationId,
      'longitude': longitude,
      'lottypeImage': lottypeImage,
      'lotTypId': lotTypId,
      'maxCapacity': maxCapacity,
      'minCapacity': minCapacity,
      'parkinglotId': parkinglotId,
      'parkingLotType': parkingLotType,
      'updatedAt': updatedAt,
      'vehicleTypeId': vehicleTypeId,
      'vendorId': vendorId,
    };
  }
}
