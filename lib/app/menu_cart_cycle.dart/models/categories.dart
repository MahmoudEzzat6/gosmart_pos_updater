// To parse this JSON data, do
//
//     final categories = categoriesFromJson(jsonString);

import 'dart:convert';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  int? status;
  List<Datum>? data;

  Categories({
    this.status,
    this.data,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
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
  bool? isPublished;
  bool? isArchived;
  bool? allCateg;
  String? image;

  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.isPublished,
    this.isArchived,
    this.allCateg,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        isPublished: json["is_published"],
        isArchived: json["is_archived"],
        allCateg: json["all_categ"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "is_published": isPublished,
        "is_archived": isArchived,
        "all_categ": allCateg,
        "image": image,
      };
}
