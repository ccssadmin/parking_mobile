class Parkinglots {
  int? availableSlots;
  DateTime? createdAt;
  double? latitude;
  int? locationId;
  double? longitude;
  int? maxCapacity;
  int? minCapacity;
  String? name;
  int? parkinglotId;
  String? parkingLotType;
  DateTime? updatedAt;
  int? vehicleTypeId;
  int? vendorId;

  Parkinglots({
    this.availableSlots,
    this.createdAt,
    this.latitude,
    this.locationId,
    this.longitude,
    this.maxCapacity,
    this.minCapacity,
    this.name,
    this.parkinglotId,
    this.parkingLotType,
    this.updatedAt,
    this.vehicleTypeId,
    this.vendorId,
  });

  // Convert JSON to Parkinglots object
  factory Parkinglots.fromJson(Map<String, dynamic> json) {
    return Parkinglots(
      availableSlots: json['availableSlots'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      latitude: json['latitude']?.toDouble(),
      locationId: json['locationId'],
      longitude: json['longitude']?.toDouble(),
      maxCapacity: json['maxCapacity'],
      minCapacity: json['minCapacity'],
      name: json['name'],
      parkinglotId: json['parkinglotId'],
      parkingLotType: json['parkingLotType'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      vehicleTypeId: json['vehicleTypeId'],
      vendorId: json['vendorId'],
    );
  }

  // Convert Parkinglots object to JSON
  Map<String, dynamic> toJson() {
    return {
      'availableSlots': availableSlots,
      'createdAt': createdAt?.toIso8601String(),
      'latitude': latitude,
      'locationId': locationId,
      'longitude': longitude,
      'maxCapacity': maxCapacity,
      'minCapacity': minCapacity,
      'name': name,
      'parkinglotId': parkinglotId,
      'parkingLotType': parkingLotType,
      'updatedAt': updatedAt?.toIso8601String(),
      'vehicleTypeId': vehicleTypeId,
      'vendorId': vendorId,
    };
  }
}
