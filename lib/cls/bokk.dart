class Bode {
  Data? data;

  Bode({this.data});

  Bode.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  CreateBookingDetails? createBookingDetails;

  Data({this.createBookingDetails});

  Data.fromJson(Map<String, dynamic> json) {
    createBookingDetails = json['createBookingDetails'] != null
        ? CreateBookingDetails.fromJson(json['createBookingDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.createBookingDetails != null) {
      data['createBookingDetails'] = this.createBookingDetails!.toJson();
    }
    return data;
  }
}

class CreateBookingDetails {
  String? message;
  bool? success;
  BookingData? data;

  CreateBookingDetails({this.message, this.success, this.data});

  CreateBookingDetails.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? BookingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookingData {
  int? bookingDetailId;
  int? bookingId;
  int? charge;
  String? createdAt;
  String? description;

  BookingData(
      {this.bookingDetailId,
      this.bookingId,
      this.charge,
      this.createdAt,
      this.description});

  BookingData.fromJson(Map<String, dynamic> json) {
    bookingDetailId = json['bookingDetailId'];
    bookingId = json['bookingId'];
    charge = json['charge'];
    createdAt = json['createdAt'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingDetailId'] = this.bookingDetailId;
    data['bookingId'] = this.bookingId;
    data['charge'] = this.charge;
    data['createdAt'] = this.createdAt;
    data['description'] = this.description;
    return data;
  }
}
