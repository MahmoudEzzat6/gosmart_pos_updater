// To parse this JSON data, do
//
//     final addDeliveryUser = addDeliveryUserFromJson(jsonString);

import 'dart:convert';

AddDeliveryUser addDeliveryUserFromJson(String str) => AddDeliveryUser.fromJson(json.decode(str));

String addDeliveryUserToJson(AddDeliveryUser data) => json.encode(data.toJson());

class AddDeliveryUser {
  int? status;
  String? message;
  String? messageAr;
  int? resDeliveryId;

  AddDeliveryUser({
    this.status,
    this.message,
    this.messageAr,
    this.resDeliveryId,
  });

  factory AddDeliveryUser.fromJson(Map<String, dynamic> json) => AddDeliveryUser(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        resDeliveryId: json["res_delivery_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "res_delivery_id": resDeliveryId,
      };
}
