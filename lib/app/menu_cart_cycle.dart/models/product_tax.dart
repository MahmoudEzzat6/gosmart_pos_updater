// To parse this JSON data, do
//
//     final productTax = productTaxFromJson(jsonString);

import 'dart:convert';

ProductTax productTaxFromJson(String str) => ProductTax.fromJson(json.decode(str));

String productTaxToJson(ProductTax data) => json.encode(data.toJson());

class ProductTax {
  int? status;
  List<Datum>? data;

  ProductTax({
    this.status,
    this.data,
  });

  factory ProductTax.fromJson(Map<String, dynamic> json) => ProductTax(
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
  String? usage;
  String? taxType;
  String? usedOn;
  String? name;
  double? amount;
  bool? active;

  Datum({
    this.id,
    this.usage,
    this.taxType,
    this.usedOn,
    this.name,
    this.amount,
    this.active,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        usage: json["usage"],
        taxType: json["tax_type"],
        usedOn: json["used_on"],
        name: json["name"],
        amount: json["amount"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "usage": usage,
        "tax_type": taxType,
        "used_on": usedOn,
        "name": name,
        "amount": amount,
        "active": active,
      };
}
