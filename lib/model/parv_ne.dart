class Parss {
  DataWrapper? data;

  Parss({this.data});

  factory Parss.fromJson(Map<String, dynamic> json) {
    return Parss(
      data: json['data'] != null ? DataWrapper.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class DataWrapper {
  SlotsByParkingLotId? slotsByParkingLotId;

  DataWrapper({this.slotsByParkingLotId});

  factory DataWrapper.fromJson(Map<String, dynamic> json) {
    return DataWrapper(
      slotsByParkingLotId: json['slotsByParkingLotId'] != null
          ? SlotsByParkingLotId.fromJson(json['slotsByParkingLotId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slotsByParkingLotId': slotsByParkingLotId?.toJson(),
    };
  }
}

class SlotsByParkingLotId {
  String? message;
  bool? success;
  List<SlotData>? data;

  SlotsByParkingLotId({this.message, this.success, this.data});

  factory SlotsByParkingLotId.fromJson(Map<String, dynamic> json) {
    return SlotsByParkingLotId(
      message: json['message'],
      success: json['success'],
      data: (json['data'] as List?)?.map((v) => SlotData.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class SlotData {
  String? createdAt;
  bool? isOccupied;
  int? parkinglotId;
  int? slotId;
  String? slotNumber;
  String? slotStatus;
  String? updatedAt;

  SlotData(
      {this.createdAt,
      this.isOccupied,
      this.parkinglotId,
      this.slotId,
      this.slotNumber,
      this.slotStatus,
      this.updatedAt});

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      createdAt: json['createdAt'],
      isOccupied: json['isOccupied'],
      parkinglotId: json['parkinglotId'],
      slotId: json['slotId'],
      slotNumber: json['slotNumber'],
      slotStatus: json['slotStatus'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'isOccupied': isOccupied,
      'parkinglotId': parkinglotId,
      'slotId': slotId,
      'slotNumber': slotNumber,
      'slotStatus': slotStatus,
      'updatedAt': updatedAt,
    };
  }
}
