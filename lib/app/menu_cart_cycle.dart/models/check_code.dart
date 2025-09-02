// To parse this JSON data, do
//
//     final checkCode = checkCodeFromJson(jsonString);

import 'dart:convert';

CheckCode checkCodeFromJson(String str) => CheckCode.fromJson(json.decode(str));

String checkCodeToJson(CheckCode data) => json.encode(data.toJson());

class CheckCode {
    int? status;
    String? message;

    CheckCode({
        this.status,
        this.message,
    });

    factory CheckCode.fromJson(Map<String, dynamic> json) => CheckCode(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
