// To parse this JSON data, do
//
//     final statusMsgModel = statusMsgModelFromJson(jsonString);

import 'dart:convert';

StatusMsgModel statusMsgModelFromJson(String str) => StatusMsgModel.fromJson(json.decode(str));

String statusMsgModelToJson(StatusMsgModel data) => json.encode(data.toJson());

class StatusMsgModel {
  int? status;
  String? messageAr;
  String? message;

  StatusMsgModel({
    this.status,
    this.messageAr,
    this.message,
  });

  factory StatusMsgModel.fromJson(Map<String, dynamic> json) => StatusMsgModel(
        status: json["status"],
        messageAr: json["message_ar"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message_ar": messageAr,
        "message": message,
      };
}
