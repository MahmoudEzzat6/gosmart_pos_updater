// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
  int? status;
  List<Datum>? data;

  Products({
    this.status,
    this.data,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
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
  String? defaultCode;
  double? listPrice;
  String? description;
  String? descriptionAr;
  int? categId;
  String? categoryName;
  bool? active;
  bool? isPublished;
  bool? isArchived;
  bool? isVariant;
  bool? small;
  double? smallPrice;
  bool? medium;
  double? mediumPrice;
  bool? large;
  double? largePrice;
  double? calories;
  String? image;
  List<int>? taxesId;
  double? qtyAvailable;
  double? virtualAvailable;

  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.defaultCode,
    this.listPrice,
    this.description,
    this.descriptionAr,
    this.categId,
    this.categoryName,
    this.active,
    this.isPublished,
    this.isArchived,
    this.isVariant,
    this.small,
    this.smallPrice,
    this.medium,
    this.mediumPrice,
    this.large,
    this.largePrice,
    this.calories,
    this.image,
    this.taxesId,
    this.qtyAvailable,
    this.virtualAvailable,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        defaultCode: json["default_code"],
        listPrice: json["list_price"]?.toDouble(),
        description: json["description"],
        descriptionAr: json["description_ar"],
        categId: json["categ_id"],
        categoryName: json["category_name"],
        active: json["active"],
        isPublished: json["is_published"],
        isArchived: json["is_archived"],
        isVariant: json["is_variant"],
        small: json["small"],
        smallPrice: json["small_price"]?.toDouble(),
        medium: json["medium"],
        mediumPrice: json["medium_price"]?.toDouble(),
        large: json["large"],
        largePrice: json["large_price"]?.toDouble(),
        calories: json["calories"],
        image: json["image"],
        taxesId: json["taxes_id"] == null ? [] : List<int>.from(json["taxes_id"]!.map((x) => x)),
        qtyAvailable: json["qty_available"],
        virtualAvailable: json["virtual_available"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "default_code": defaultCode,
        "list_price": listPrice,
        "description": description,
        "description_ar": descriptionAr,
        "categ_id": categId,
        "category_name": categoryName,
        "active": active,
        "is_published": isPublished,
        "is_archived": isArchived,
        "is_variant": isVariant,
        "small": small,
        "small_price": smallPrice,
        "medium": medium,
        "medium_price": mediumPrice,
        "large": large,
        "large_price": largePrice,
        "calories": calories,
        "image": image,
      };
}
