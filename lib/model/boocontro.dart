class BookingResponse {
  BookingData? data;

  BookingResponse({this.data});

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookingData {
  CreateBooking? createBooking;

  BookingData({this.createBooking});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      createBooking: json['createBooking'] != null
          ? CreateBooking.fromJson(json['createBooking'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.createBooking != null) {
      data['createBooking'] = this.createBooking!.toJson();
    }
    return data;
  }
}

class CreateBooking {
  String? message;
  bool? success;
  BookingDetails? data;

  CreateBooking({this.message, this.success, this.data});

  factory CreateBooking.fromJson(Map<String, dynamic> json) {
    return CreateBooking(
      message: json['message'],
      success: json['success'],
      data: json['data'] != null ? BookingDetails.fromJson(json['data']) : null,
    );
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

class BookingDetails {
  String? bookingDate;
  int? bookingId;
  String? bookingStatus;
  String? createdAt;
  String? inDate;
  String? inTime;
  String? outDate;
  String? outTime;
  int? parkingSlotId;
  String? paymentStatus;
  int? totalAmount;
  String? totalHours;
  String? updatedAt; // Changed from Null to String?
  int? userId;
  int? vehicleId;

  BookingDetails({
    this.bookingDate,
    this.bookingId,
    this.bookingStatus,
    this.createdAt,
    this.inDate,
    this.inTime,
    this.outDate,
    this.outTime,
    this.parkingSlotId,
    this.paymentStatus,
    this.totalAmount,
    this.totalHours,
    this.updatedAt,
    this.userId,
    this.vehicleId,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      bookingDate: json['bookingDate'],
      bookingId: json['bookingId'],
      bookingStatus: json['bookingStatus'],
      createdAt: json['createdAt'],
      inDate: json['inDate'],
      inTime: json['inTime'],
      outDate: json['outDate'],
      outTime: json['outTime'],
      parkingSlotId: json['parkingSlotId'],
      paymentStatus: json['paymentStatus'],
      totalAmount: json['totalAmount'],
      totalHours: json['totalHours'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bookingDate'] = bookingDate;
    data['bookingId'] = bookingId;
    data['bookingStatus'] = bookingStatus;
    data['createdAt'] = createdAt;
    data['inDate'] = inDate;
    data['inTime'] = inTime;
    data['outDate'] = outDate;
    data['outTime'] = outTime;
    data['parkingSlotId'] = parkingSlotId;
    data['paymentStatus'] = paymentStatus;
    data['totalAmount'] = totalAmount;
    data['totalHours'] = totalHours;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    data['vehicleId'] = vehicleId;
    return data;
  }
}
