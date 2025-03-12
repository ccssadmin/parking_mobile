class Vehicle {
  String? color;
  String? createdAt;
  bool? isActive;
  bool? isRegistered;
  String? makeModel;
  String? notes;
  String? registrationDate;
  String? updatedAt;
  int? userId;
  int? vehicleId;
  String? vehicleNumber;
  int? vehicleTypeId;
  int? year;
  User? user;

  Vehicle({
    this.color,
    this.createdAt,
    this.isActive,
    this.isRegistered,
    this.makeModel,
    this.notes,
    this.registrationDate,
    this.updatedAt,
    this.userId,
    this.vehicleId,
    this.vehicleNumber,
    this.vehicleTypeId,
    this.year,
    this.user,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    print("Parsing Vehicle JSON: $json"); // Debug log
    return Vehicle(
      color: json['color'],
      createdAt: json['createdAt'],
      isActive: json['isActive'],
      isRegistered: json['isRegistered'],
      makeModel: json['makeModel'],
      notes: json['notes'],
      registrationDate: json['registrationDate'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
      vehicleNumber: json['vehicleNumber'],
      vehicleTypeId: json['vehicleTypeId'],
      year: json['year'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'createdAt': createdAt,
      'isActive': isActive,
      'isRegistered': isRegistered,
      'makeModel': makeModel,
      'notes': notes,
      'registrationDate': registrationDate,
      'updatedAt': updatedAt,
      'userId': userId,
      'vehicleId': vehicleId,
      'vehicleNumber': vehicleNumber,
      'vehicleTypeId': vehicleTypeId,
      'year': year,
      'user': user?.toJson(),
    };
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

  User({
    this.aadhaarNumber,
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
    this.vehicleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print("Parsing User JSON: $json"); // Debug log
    return User(
      aadhaarNumber: json['aadhaarNumber'],
      createdAt: json['createdAt'],
      email: json['email'],
      firstName: json['firstName'],
      isActive: json['isActive'],
      isKycVerified: json['isKycVerified'],
      isMobileVerified: json['isMobileVerified'],
      lastName: json['lastName'],
      password: json['password'],
      passwordHash: json['passwordHash'],
      phoneNumber: json['phoneNumber'],
      profileUrl: json['profileUrl'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aadhaarNumber': aadhaarNumber,
      'createdAt': createdAt,
      'email': email,
      'firstName': firstName,
      'isActive': isActive,
      'isKycVerified': isKycVerified,
      'isMobileVerified': isMobileVerified,
      'lastName': lastName,
      'password': password,
      'passwordHash': passwordHash,
      'phoneNumber': phoneNumber,
      'profileUrl': profileUrl,
      'updatedAt': updatedAt,
      'userId': userId,
      'vehicleId': vehicleId,
    };
  }
}
