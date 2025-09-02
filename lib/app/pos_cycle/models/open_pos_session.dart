// To parse this JSON data, do
//
//     final openPosSession = openPosSessionFromJson(jsonString);

import 'dart:convert';

OpenPosSession openPosSessionFromJson(String str) => OpenPosSession.fromJson(json.decode(str));

String openPosSessionToJson(OpenPosSession data) => json.encode(data.toJson());

class OpenPosSession {
  int? status;
  String? message;
  String? messageAr;
  int? sessionId;

  OpenPosSession({
    this.status,
    this.message,
    this.messageAr,
    this.sessionId,
  });

  factory OpenPosSession.fromJson(Map<String, dynamic> json) => OpenPosSession(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        sessionId: json["session_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "session_id": sessionId,
      };
}
