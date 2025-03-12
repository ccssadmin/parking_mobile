class Book {
  final BookingData? data;

  Book({this.data});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      data: json['data'] != null ? BookingData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookingData {
  final CreateBooking? createBooking;

  BookingData({this.createBooking});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      createBooking: json['createBooking'] != null
          ? CreateBooking.fromJson(json['createBooking'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (createBooking != null) {
      data['createBooking'] = createBooking!.toJson();
    }
    return data;
  }
}

class CreateBooking {
  final String? message;
  final bool? success;
  final BookingDetails? data;

  CreateBooking({this.message, this.success, this.data});

  factory CreateBooking.fromJson(Map<String, dynamic> json) {
    return CreateBooking(
      message: json['message'],
      success: json['success'],
      data: json['data'] != null ? BookingDetails.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookingDetails {
  final String? bookingDate;
  final int? bookingId;
  final String? bookingStatus;
  final String? createdAt;
  final String? inDate;
  final String? inTime;
  final String? outDate;
  final String? outTime;
  final int? parkingSlotId;
  final String? paymentStatus;
  final int? totalHours;
  final String? updatedAt;
  final int? userId;
  final String? vehicleId;

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
      totalHours: json['totalHours'],
      updatedAt: json['updatedAt'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['totalHours'] = totalHours;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    data['vehicleId'] = vehicleId;
    return data;
  }
}
