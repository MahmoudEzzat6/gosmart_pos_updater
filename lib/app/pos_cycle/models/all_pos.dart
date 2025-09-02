// To parse this JSON data, do
//
//     final allPos = allPosFromJson(jsonString);

import 'dart:convert';

AllPos allPosFromJson(String str) => AllPos.fromJson(json.decode(str));

String allPosToJson(AllPos data) => json.encode(data.toJson());

class AllPos {
  int? status;
  List<Datum>? data;

  AllPos({
    this.status,
    this.data,
  });

  factory AllPos.fromJson(Map<String, dynamic> json) => AllPos(
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
  bool? active;
  bool? hasActiveSession;
  String? currentSession;
  int? currentSessionId;
  String? lastSessionClosingDate;
  double? lastSessionClosingCash;
  String? lastSessionUsername;
  String? lastSessionState;
  String? lastSessionDuration;

  Datum({
    this.id,
    this.name,
    this.active,
    this.hasActiveSession,
    this.currentSession,
    this.currentSessionId,
    this.lastSessionClosingDate,
    this.lastSessionClosingCash,
    this.lastSessionUsername,
    this.lastSessionState,
    this.lastSessionDuration,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        active: json["active"],
        hasActiveSession: json["has_active_session"],
        currentSession: json["current_session"],
        currentSessionId: json["current_session_id"],
        lastSessionClosingDate: json["last_session_closing_date"],
        lastSessionClosingCash: json["last_session_closing_cash"],
        lastSessionUsername: json["last_session_username"],
        lastSessionState: json["last_session_state"],
        lastSessionDuration: json["last_session_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "active": active,
        "has_active_session": hasActiveSession,
        "current_session": currentSession,
        "current_session_id": currentSessionId,
        "last_session_closing_cash": lastSessionClosingCash,
        "last_session_username": lastSessionUsername,
        "last_session_state": lastSessionState,
        "last_session_duration": lastSessionDuration,
      };
}
