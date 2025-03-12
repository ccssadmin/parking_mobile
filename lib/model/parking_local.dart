import 'package:par/model/search_query.dart';

class ParkingLotss {
  final String? locationName;
  final String? address;
  final int? cityId;
  final double? latitude;
  final double? longitude;
  final int? locationId;
  final List<ParkingLot>? parkingLots;

  ParkingLotss({
    this.locationName,
    this.address,
    this.cityId,
    this.latitude,
    this.longitude,
    this.locationId,
    this.parkingLots,
  });
}

class ParkingLocationl {
  final String? locationName;
  final String? address;
  final int? cityId;
  final double? latitude;
  final double? longitude;
  final int? locationId;
  List<ParkingLot>? parkingLots;

  ParkingLocationl({
    this.locationName,
    this.address,
    this.cityId,
    this.latitude,
    this.longitude,
    this.locationId,
    this.parkingLots,
  });

  factory ParkingLocationl.fromJson(Map<String, dynamic> json) {
    return ParkingLocationl(
        locationName: json['locationName'],
        address: json['address'],
        cityId: json['cityId'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        locationId: json['locationId'],
        parkingLots: json['parkingLots']);
  }
}
