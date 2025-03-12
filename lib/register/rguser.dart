class Rjss {
  Data? data;

  Rjss({this.data});

  Rjss.fromJson(Map<String, dynamic> json) {
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
  RegisterUser? registerUser;

  Data({this.registerUser});

  Data.fromJson(Map<String, dynamic> json) {
    registerUser = json['registerUser'] != null
        ? new RegisterUser.fromJson(json['registerUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.registerUser != null) {
      data['registerUser'] = this.registerUser!.toJson();
    }
    return data;
  }
}

class RegisterUser {
  String? message;
  bool? success;
  RegisterData? data;

  RegisterUser({this.message, this.success, this.data});

  RegisterUser.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data =
        json['data'] != null ? new RegisterData.fromJson(json['data']) : null;
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

class RegisterData {
  String? otpCode;
  User? user;

  RegisterData({this.otpCode, this.user});

  RegisterData.fromJson(Map<String, dynamic> json) {
    otpCode = json['otpCode'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpCode'] = this.otpCode;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? aadhaarNumber;
  String? createdAt;
  String? email;
  String? firstName;
  bool? isActive;
  bool? isKycVerified;
  bool? isMobileVerified;
  String? lastName;
  String? password;
  String? passwordHash;
  String? phoneNumber;
  String? profileUrl;
  String? updatedAt;
  int? userId;
  int? vehicleId;

  User(
      {this.aadhaarNumber,
      this.createdAt,
      this.email,
      this.firstName,
      this.isActive,
      this.isKycVerified,
      this.isMobileVerified,
      this.lastName,
      this.password,
      this.passwordHash,
      this.phoneNumber,
      this.profileUrl,
      this.updatedAt,
      this.userId,
      this.vehicleId});

  User.fromJson(Map<String, dynamic> json) {
    aadhaarNumber = json['aadhaarNumber'];
    createdAt = json['createdAt'];
    email = json['email'];
    firstName = json['firstName'];
    isActive = json['isActive'];
    isKycVerified = json['isKycVerified'];
    isMobileVerified = json['isMobileVerified'];
    lastName = json['lastName'];
    password = json['password'];
    passwordHash = json['passwordHash'];
    phoneNumber = json['phoneNumber'];
    profileUrl = json['profileUrl'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    vehicleId = json['vehicleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aadhaarNumber'] = this.aadhaarNumber;
    data['createdAt'] = this.createdAt;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['isActive'] = this.isActive;
    data['isKycVerified'] = this.isKycVerified;
    data['isMobileVerified'] = this.isMobileVerified;
    data['lastName'] = this.lastName;
    data['password'] = this.password;
    data['passwordHash'] = this.passwordHash;
    data['phoneNumber'] = this.phoneNumber;
    data['profileUrl'] = this.profileUrl;
    data['updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['vehicleId'] = this.vehicleId;
    return data;
  }
}
