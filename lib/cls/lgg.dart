class Kg {
  KgData? data;

  Kg({this.data});

  Kg.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? KgData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class KgData {
  CreateLotType? createLotType;

  KgData({this.createLotType});

  KgData.fromJson(Map<String, dynamic> json) {
    createLotType = json['createLotType'] != null
        ? CreateLotType.fromJson(json['createLotType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (createLotType != null) {
      data['createLotType'] = createLotType!.toJson();
    }
    return data;
  }
}

class CreateLotType {
  String? message;
  bool? success;
  LotTypeData? data;

  CreateLotType({this.message, this.success, this.data});

  CreateLotType.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? LotTypeData.fromJson(json['data']) : null;
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

class LotTypeData {
  int? lotTypeId;
  String? lottypeurl;
  String? parkingLotType;

  LotTypeData({this.lotTypeId, this.lottypeurl, this.parkingLotType});

  LotTypeData.fromJson(Map<String, dynamic> json) {
    lotTypeId = json['lotTypeId'];
    lottypeurl = json['lottypeurl'];
    parkingLotType = json['paringlotType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lotTypeId'] = lotTypeId;
    data['lottypeurl'] = lottypeurl;
    data['parkingLotType'] = parkingLotType;
    return data;
  }
}
