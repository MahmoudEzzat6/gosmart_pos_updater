// To parse this JSON data, do
//
//     final posSessions = posSessionsFromJson(jsonString);

import 'dart:convert';

PosSessions posSessionsFromJson(String str) => PosSessions.fromJson(json.decode(str));

String posSessionsToJson(PosSessions data) => json.encode(data.toJson());

class PosSessions {
  int? status;
  List<Datum>? data;

  PosSessions({
    this.status,
    this.data,
  });

  factory PosSessions.fromJson(Map<String, dynamic> json) => PosSessions(
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
  int? posId;
  String? posName;
  int? cashierId;
  String? cashierName;
  double? openingCash;
  double? closingCash;
  String? state;
  String? startAt;
  String? stopAt;
  String? openingNotes;
  String? closingNotes;
  int? ordersCount;
  double? totalPaymentsAmount;

  Datum({
    this.id,
    this.name,
    this.posId,
    this.posName,
    this.cashierId,
    this.cashierName,
    this.openingCash,
    this.closingCash,
    this.state,
    this.startAt,
    this.stopAt,
    this.openingNotes,
    this.closingNotes,
    this.ordersCount,
    this.totalPaymentsAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        posId: json["pos_id"],
        posName: json["pos_name"],
        cashierId: json["cashier_id"],
        cashierName: json["cashier_name"],
        openingCash: json["opening_cash"]?.toDouble(),
        closingCash: json["closing_cash"]?.toDouble(),
        state: json["state"],
        startAt: json["start_at"],
        stopAt: json["stop_at"],
        openingNotes: json["opening_notes"],
        closingNotes: json["closing_notes"],
        ordersCount: json["orders_count"],
        totalPaymentsAmount: json["total_payments_amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pos_id": posId,
        "pos_name": posName,
        "cashier_id": cashierId,
        "cashier_name": cashierName,
        "opening_cash": openingCash,
        "closing_cash": closingCash,
        "state": state,
        "start_at": startAt,
        "stop_at": stopAt,
        "opening_notes": openingNotes,
        "closing_notes": closingNotes,
        "orders_count": ordersCount,
        "total_payments_amount": totalPaymentsAmount,
      };
}
