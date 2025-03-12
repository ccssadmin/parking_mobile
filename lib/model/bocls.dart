class Bdetail {
  Data? data;

  Bdetail({this.data});

  factory Bdetail.fromJson(Map<String, dynamic> json) {
    return Bdetail(
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
  BookingDetailsByUserId? bookingDetailsByUserId;

  Data({this.bookingDetailsByUserId});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      bookingDetailsByUserId: json['bookingDetailsByUserId'] != null
          ? BookingDetailsByUserId.fromJson(json['bookingDetailsByUserId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingDetailsByUserId': bookingDetailsByUserId?.toJson(),
    };
  }
}

class BookingDetailsByUserId {
  String? message;
  bool? success;
  List<BookingData>? data;

  BookingDetailsByUserId({this.message, this.success, this.data});

  factory BookingDetailsByUserId.fromJson(Map<String, dynamic> json) {
    return BookingDetailsByUserId(
      message: json['message'],
      success: json['success'],
      data:
          (json['data'] as List?)?.map((v) => BookingData.fromJson(v)).toList(),
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

class BookingData {
  String? bookingDate;
  int? bookingId;
  String? bookingStatus;
  String? createdAt;
  int? parkingSlotId;
  String? paymentStatus;
  dynamic updatedAt;
  int? userId;
  dynamic vehicleId;

  BookingData({
    this.bookingDate,
    this.bookingId,
    this.bookingStatus,
    this.createdAt,
    this.parkingSlotId,
    this.paymentStatus,
    this.updatedAt,
    this.userId,
    this.vehicleId,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookingDate: json['bookingDate'],
      bookingId: json['bookingId'],
      bookingStatus: json['bookingStatus'],
      createdAt: json['createdAt'],
      parkingSlotId: json['parkingSlotId'],
      paymentStatus: json['paymentStatus'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingDate': bookingDate,
      'bookingId': bookingId,
      'bookingStatus': bookingStatus,
      'createdAt': createdAt,
      'parkingSlotId': parkingSlotId,
      'paymentStatus': paymentStatus,
      'updatedAt': updatedAt,
      'userId': userId,
      'vehicleId': vehicleId,
    };
  }
}
