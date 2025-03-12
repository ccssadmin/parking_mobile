class Slo {
  SloData? data;

  Slo({this.data});

  Slo.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? SloData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SloData {
  CreateSlot? createSlot;

  SloData({this.createSlot});

  SloData.fromJson(Map<String, dynamic> json) {
    createSlot = json['createSlot'] != null
        ? CreateSlot.fromJson(json['createSlot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.createSlot != null) {
      data['createSlot'] = this.createSlot!.toJson();
    }
    return data;
  }
}

class CreateSlot {
  String? message;
  bool? success;
  SlotData? data;

  CreateSlot({this.message, this.success, this.data});

  CreateSlot.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? SlotData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
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

  SlotData({
    this.createdAt,
    this.isOccupied,
    this.parkinglotId,
    this.slotId,
    this.slotNumber,
    this.slotStatus,
    this.updatedAt,
  });

  SlotData.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    isOccupied = json['isOccupied'];
    parkinglotId = json['parkinglotId'];
    slotId = json['slotId'];
    slotNumber = json['slotNumber'];
    slotStatus = json['slotStatus'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['createdAt'] = createdAt;
    data['isOccupied'] = isOccupied;
    data['parkinglotId'] = parkinglotId;
    data['slotId'] = slotId;
    data['slotNumber'] = slotNumber;
    data['slotStatus'] = slotStatus;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
