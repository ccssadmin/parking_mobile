class Partic {
  Data? data;

  Partic({this.data});

  Partic.fromJson(Map<String, dynamic> json) {
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
  CreateTickets? createTickets;

  Data({this.createTickets});

  Data.fromJson(Map<String, dynamic> json) {
    createTickets = json['createTickets'] != null
        ? CreateTickets.fromJson(json['createTickets'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (createTickets != null) {
      data['createTickets'] = createTickets!.toJson();
    }
    return data;
  }
}

class CreateTickets {
  String? message;
  bool? success;
  TicketData? data;

  CreateTickets({this.message, this.success, this.data});

  CreateTickets.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? TicketData.fromJson(json['data']) : null;
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

class TicketData {
  int? bookingId;
  String? createdAt;
  String? issuedAt;
  String? locationName;
  String? lotName;
  String? mode;
  int? slotId;
  int? ticketId;
  double? ticketPrice;
  String? ticketStatus;
  String? ticketType;
  String? totalHours;
  String? trackingId;
  int? userId;
  String? validFrom;
  String? validUntil;
  int? vehicleId;

  TicketData({
    this.bookingId,
    this.createdAt,
    this.issuedAt,
    this.locationName,
    this.lotName,
    this.mode,
    this.slotId,
    this.ticketId,
    this.ticketPrice,
    this.ticketStatus,
    this.ticketType,
    this.totalHours,
    this.trackingId,
    this.userId,
    this.validFrom,
    this.validUntil,
    this.vehicleId,
  });

  TicketData.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    createdAt = json['createdAt'];
    issuedAt = json['issuedAt'];
    locationName = json['locationName'];
    lotName = json['lotName'];
    mode = json['mode'];
    slotId = json['slotId'];
    ticketId = json['ticketId'];
    ticketPrice = json['ticketPrice'];
    ticketStatus = json['ticketStatus'];
    ticketType = json['ticketType'];
    totalHours = json['totalHours'];
    trackingId = json['trackingId'];
    userId = json['userId'];
    validFrom = json['validFrom'];
    validUntil = json['validUntil'];
    vehicleId = json['vehicleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingId'] = bookingId;
    data['createdAt'] = createdAt;
    data['issuedAt'] = issuedAt;
    data['locationName'] = locationName;
    data['lotName'] = lotName;
    data['mode'] = mode;
    data['slotId'] = slotId;
    data['ticketId'] = ticketId;
    data['ticketPrice'] = ticketPrice;
    data['ticketStatus'] = ticketStatus;
    data['ticketType'] = ticketType;
    data['totalHours'] = totalHours;
    data['trackingId'] = trackingId;
    data['userId'] = userId;
    data['validFrom'] = validFrom;
    data['validUntil'] = validUntil;
    data['vehicleId'] = vehicleId;
    return data;
  }
}
