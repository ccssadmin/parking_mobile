class VehiclesDet {
  Data? data;

  VehiclesDet({this.data});

  factory VehiclesDet.fromJson(Map<String, dynamic> json) {
    return VehiclesDet(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class Data {
  List<Vehicles>? vehicles;

  Data({this.vehicles});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      vehicles: json['vehicles'] != null
          ? List<Vehicles>.from(
              json['vehicles'].map((v) => Vehicles.fromJson(v)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicles': vehicles?.map((v) => v.toJson()).toList(),
    };
  }
}

class Vehicles {
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
  List<dynamic>? appusers;
  List<dynamic>? bookings;
  List<dynamic>? tickets;
  dynamic user;
  List<dynamic>? vehicleTrackings;
  dynamic vehicleType;

  Vehicles({
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
    this.appusers,
    this.bookings,
    this.tickets,
    this.user,
    this.vehicleTrackings,
    this.vehicleType,
  });

  factory Vehicles.fromJson(Map<String, dynamic> json) {
    return Vehicles(
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
      appusers: json['appusers'] ?? [],
      bookings: json['bookings'] ?? [],
      tickets: json['tickets'] ?? [],
      user: json['user'],
      vehicleTrackings: json['vehicleTrackings'] ?? [],
      vehicleType: json['vehicleType'],
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
      'appusers': appusers,
      'bookings': bookings,
      'tickets': tickets,
      'user': user,
      'vehicleTrackings': vehicleTrackings,
      'vehicleType': vehicleType,
    };
  }
}
