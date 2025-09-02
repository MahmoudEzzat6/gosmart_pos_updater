// To parse this JSON data, do
//
//     final addPosModel = addPosModelFromJson(jsonString);

import 'dart:convert';

AddPosModel addPosModelFromJson(String str) => AddPosModel.fromJson(json.decode(str));

String addPosModelToJson(AddPosModel data) => json.encode(data.toJson());

class AddPosModel {
  int? status;
  String? messageAr;
  String? message;
  int? newPosId;

  AddPosModel({
    this.status,
    this.messageAr,
    this.message,
    this.newPosId,
  });

  factory AddPosModel.fromJson(Map<String, dynamic> json) => AddPosModel(
        status: json["status"],
        messageAr: json["message_ar"],
        message: json["message"],
        newPosId: json["new_pos_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message_ar": messageAr,
        "message": message,
        "new_pos_id": newPosId,
      };
}
