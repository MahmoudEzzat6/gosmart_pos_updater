// To parse this JSON data, do
//
//     final availablePaymentMethods = availablePaymentMethodsFromJson(jsonString);

import 'dart:convert';

AvailablePaymentMethods availablePaymentMethodsFromJson(String str) => AvailablePaymentMethods.fromJson(json.decode(str));

String availablePaymentMethodsToJson(AvailablePaymentMethods data) => json.encode(data.toJson());

class AvailablePaymentMethods {
  int? status;
  List<Datum>? data;

  AvailablePaymentMethods({
    this.status,
    this.data,
  });

  factory AvailablePaymentMethods.fromJson(Map<String, dynamic> json) => AvailablePaymentMethods(
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
  String? type;
  int? journalId;
  String? journalName;
  bool? active;
  int? posId;

  Datum({
    this.id,
    this.name,
    this.type,
    this.journalId,
    this.journalName,
    this.active,
    this.posId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        journalId: json["journal_id"],
        journalName: json["journal_name"],
        active: json["active"],
        posId: json["pos_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "journal_id": journalId,
        "journal_name": journalName,
        "active": active,
        "pos_id": posId,
      };
}
