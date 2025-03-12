class Sd {
  Data? data;

  Sd({this.data});

  Sd.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  CreateSlot? createSlot;

  Data({this.createSlot});

  Data.fromJson(Map<String, dynamic> json) {
    createSlot = json['createSlot'] != null
        ? new CreateSlot.fromJson(json['createSlot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data = json['data'] != null ? new SlotData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
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

  SlotData(
      {this.createdAt,
      this.isOccupied,
      this.parkinglotId,
      this.slotId,
      this.slotNumber,
      this.slotStatus,
      this.updatedAt});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['isOccupied'] = this.isOccupied;
    data['parkinglotId'] = this.parkinglotId;
    data['slotId'] = this.slotId;
    data['slotNumber'] = this.slotNumber;
    data['slotStatus'] = this.slotStatus;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
