// To parse this JSON data, do
//
//     final deliveryUsers = deliveryUsersFromJson(jsonString);

import 'dart:convert';

DeliveryUsers deliveryUsersFromJson(String str) => DeliveryUsers.fromJson(json.decode(str));

String deliveryUsersToJson(DeliveryUsers data) => json.encode(data.toJson());

class DeliveryUsers {
  int? status;
  List<Datum>? data;

  DeliveryUsers({
    this.status,
    this.data,
  });

  factory DeliveryUsers.fromJson(Map<String, dynamic> json) => DeliveryUsers(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? name;
  String? phone;
  String? address;
  bool? isArchived;

  Datum({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.isArchived,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        isArchived: json["is_archived"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "is_archived": isArchived,
      };
}
