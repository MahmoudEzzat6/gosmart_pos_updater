// To parse this JSON data, do
//
//     final discountModel = discountModelFromJson(jsonString);

import 'dart:convert';

DiscountModel discountModelFromJson(String str) => DiscountModel.fromJson(json.decode(str));

String discountModelToJson(DiscountModel data) => json.encode(data.toJson());

class DiscountModel {
  int? status;
  List<Datum>? data;

  DiscountModel({
    this.status,
    this.data,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
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
  String? nameAr;
  double? listPrice;
  String? defaultCode;

  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.listPrice,
    this.defaultCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        listPrice: json["list_price"],
        defaultCode: json["default_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "list_price": listPrice,
        "default_code": defaultCode,
      };
}
