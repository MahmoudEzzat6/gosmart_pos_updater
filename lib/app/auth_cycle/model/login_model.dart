// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  int? status;
  String? message;
  String? messageAr;
  int? userId;
  int? partnerId;
  String? name;
  String? role;
  dynamic phone;
  String? email;
  bool? isArchived;

  Login({
    this.status,
    this.message,
    this.messageAr,
    this.userId,
    this.partnerId,
    this.name,
    this.role,
    this.phone,
    this.email,
    this.isArchived,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        userId: json["user_id"],
        partnerId: json["partner_id"],
        name: json["name"],
        role: json["role"],
        phone: json["phone"],
        email: json["email"],
        isArchived: json["is_archived"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "user_id": userId,
        "partner_id": partnerId,
        "name": name,
        "role": role,
        "phone": phone,
        "email": email,
        "is_archived": isArchived,
      };
}
