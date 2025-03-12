// models/park.dart
class Parks {
  final String? name;
  final int? availableSlots;
  final double? latitude;
  final double? longitude;
  final String? parkingLotType;
  final int? maxCapacity;
  final int? minCapacity;
  final int? vehicleTypeId;
  final int? vendorId;

  Parks({
    this.name,
    this.availableSlots,
    this.latitude,
    this.longitude,
    this.parkingLotType,
    this.maxCapacity,
    this.minCapacity,
    this.vehicleTypeId,
    this.vendorId,
  });
}
