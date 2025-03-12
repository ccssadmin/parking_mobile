class Lk {
  LkData? data;

  Lk({this.data});

  Lk.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? LkData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LkData {
  CreateParkingLot? createParkingLot;

  LkData({this.createParkingLot});

  LkData.fromJson(Map<String, dynamic> json) {
    createParkingLot = json['createParkingLot'] != null
        ? CreateParkingLot.fromJson(json['createParkingLot'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (createParkingLot != null) {
      data['createParkingLot'] = createParkingLot!.toJson();
    }
    return data;
  }
}

class CreateParkingLot {
  String? message;
  bool? success;
  ParkingLotData? data;

  CreateParkingLot({this.message, this.success, this.data});

  CreateParkingLot.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? ParkingLotData.fromJson(json['data']) : null;
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

class ParkingLotData {
  int? locationId;
  String? createdAt;
  String? updatedAt;
  int? lotTypId;
  int? maxCapacity;
  int? minCapacity;
  int? parkinglotId;
  String? parkingLotType;
  String? lottypeImage;
  double? latitude;
  double? longitude;
  int? vehicleTypeId;
  int? vendorId;
  String? location;
  LotTyp? lotTyp;
  List<dynamic>? slots;
  List<dynamic>? parkinglotVehicleTypes;
  List<dynamic>? lotPrices;
  dynamic vehicleType;
  dynamic vendor;
  int? availableSlots;

  ParkingLotData({
    this.locationId,
    this.createdAt,
    this.updatedAt,
    this.lotTypId,
    this.maxCapacity,
    this.minCapacity,
    this.parkinglotId,
    this.parkingLotType,
    this.lottypeImage,
    this.latitude,
    this.longitude,
    this.vehicleTypeId,
    this.vendorId,
    this.location,
    this.lotTyp,
    this.slots,
    this.parkinglotVehicleTypes,
    this.lotPrices,
    this.vehicleType,
    this.vendor,
    this.availableSlots,
  });

  ParkingLotData.fromJson(Map<String, dynamic> json) {
    locationId = json['locationId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    lotTypId = json['lotTypId'];
    maxCapacity = json['maxCapacity'];
    minCapacity = json['minCapacity'];
    parkinglotId = json['parkinglotId'];
    parkingLotType = json['parkingLotType'];
    lottypeImage = json['lottypeImage'];
    latitude = json['latitude']?.toDouble();
    longitude = json['longitude']?.toDouble();
    vehicleTypeId = json['vehicleTypeId'];
    vendorId = json['vendorId'];
    location = json['location'];
    lotTyp = json['lotTyp'] != null ? LotTyp.fromJson(json['lotTyp']) : null;
    slots = json['slots'] != null ? List<dynamic>.from(json['slots']) : null;
    parkinglotVehicleTypes = json['parkinglotVehicleTypes'] != null
        ? List<dynamic>.from(json['parkinglotVehicleTypes'])
        : null;
    lotPrices = json['lotPrices'] != null
        ? List<dynamic>.from(json['lotPrices'])
        : null;
    vehicleType = json['vehicleType'];
    vendor = json['vendor'];
    availableSlots = json['availableSlots'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['locationId'] = locationId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['lotTypId'] = lotTypId;
    data['maxCapacity'] = maxCapacity;
    data['minCapacity'] = minCapacity;
    data['parkinglotId'] = parkinglotId;
    data['parkingLotType'] = parkingLotType;
    data['lottypeImage'] = lottypeImage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['vehicleTypeId'] = vehicleTypeId;
    data['vendorId'] = vendorId;
    data['location'] = location;
    if (lotTyp != null) {
      data['lotTyp'] = lotTyp!.toJson();
    }
    if (slots != null) {
      data['slots'] = slots;
    }
    if (parkinglotVehicleTypes != null) {
      data['parkinglotVehicleTypes'] = parkinglotVehicleTypes;
    }
    if (lotPrices != null) {
      data['lotPrices'] = lotPrices;
    }
    data['vehicleType'] = vehicleType;
    data['vendor'] = vendor;
    data['availableSlots'] = availableSlots;
    return data;
  }
}

class LotTyp {
  int? lotTypeId;
  String? lottypeurl;
  String? parkinglotType;

  LotTyp({this.lotTypeId, this.lottypeurl, this.parkinglotType});

  LotTyp.fromJson(Map<String, dynamic> json) {
    lotTypeId = json['lotTypeId'];
    lottypeurl = json['lottypeurl'];
    parkinglotType = json['paringlotType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lotTypeId'] = lotTypeId;
    data['lottypeurl'] = lottypeurl;
    data['paringlotType'] = parkinglotType;
    return data;
  }
}
