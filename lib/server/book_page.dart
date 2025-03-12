class Books {
  BookingData? data;

  Books({this.data});

  Books.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? BookingData.fromJson(json['data']) : null;
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

  BookingData.fromJson(Map<String, dynamic> json) {
    createBooking = json['createBooking'] != null
        ? CreateBooking.fromJson(json['createBooking'])
        : null;
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

  CreateBooking.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? BookingDetails.fromJson(json['data']) : null;
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
  int? parkingSlotId;
  String? paymentStatus;
  int? userId;
  Object? vehicleId;

  BookingDetails({
    this.bookingDate,
    this.bookingId,
    this.bookingStatus,
    this.createdAt,
    this.parkingSlotId,
    this.paymentStatus,
    this.userId,
    this.vehicleId,
  });

  BookingDetails.fromJson(Map<String, dynamic> json) {
    bookingDate = json['bookingDate'];
    bookingId = json['bookingId'];
    bookingStatus = json['bookingStatus'];
    createdAt = json['createdAt'];
    parkingSlotId = json['parkingSlotId'];
    paymentStatus = json['paymentStatus'];
    userId = json['userId'];
    vehicleId = json['vehicleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['bookingDate'] = bookingDate;
    data['bookingId'] = bookingId;
    data['bookingStatus'] = bookingStatus;
    data['createdAt'] = createdAt;
    data['parkingSlotId'] = parkingSlotId;
    data['paymentStatus'] = paymentStatus;
    data['userId'] = userId;
    data['vehicleId'] = vehicleId;
    return data;
  }
}
