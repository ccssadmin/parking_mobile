class ParkingSlot {
  final int slotId;
  final String slotNumber;
  final bool isOccupied;
  final int parkinglotId;
  final String createdAt;
  final String updatedAt;

  ParkingSlot({
    required this.slotId,
    required this.slotNumber,
    required this.isOccupied,
    required this.parkinglotId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      slotId: json['slotId'],
      slotNumber: json['slotNumber'],
      isOccupied: json['isOccupied'],
      parkinglotId: json['parkinglotId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
