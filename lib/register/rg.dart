class Reg {
  Data? data;

  Reg({this.data});

  Reg.fromJson(Map<String, dynamic> json) {
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
  RegisterNewVehicle? registerNewVehicle;

  Data({this.registerNewVehicle});

  Data.fromJson(Map<String, dynamic> json) {
    registerNewVehicle = json['registerNewVehicle'] != null
        ? new RegisterNewVehicle.fromJson(json['registerNewVehicle'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.registerNewVehicle != null) {
      data['registerNewVehicle'] = this.registerNewVehicle!.toJson();
    }
    return data;
  }
}

class RegisterNewVehicle {
  String? message;
  bool? success;
  VehicleData? data;

  RegisterNewVehicle({this.message, this.success, this.data});

  RegisterNewVehicle.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? new VehicleData.fromJson(json['data']) : null;
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

class VehicleData {
  String? firstname;
  String? lastname;
  String? phonenumber;
  Null userid;
  String? vehiclenumber;

  VehicleData(
      {this.firstname,
      this.lastname,
      this.phonenumber,
      this.userid,
      this.vehiclenumber});

  VehicleData.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    phonenumber = json['phonenumber'];
    userid = json['userid'];
    vehiclenumber = json['vehiclenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phonenumber'] = this.phonenumber;
    data['userid'] = this.userid;
    data['vehiclenumber'] = this.vehiclenumber;
    return data;
  }
}
