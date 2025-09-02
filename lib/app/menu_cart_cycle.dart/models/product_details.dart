// To parse this JSON data, do
//
//     final productDetails = productDetailsFromJson(jsonString);

import 'dart:convert';

ProductDetails productDetailsFromJson(String str) => ProductDetails.fromJson(json.decode(str));

String productDetailsToJson(ProductDetails data) => json.encode(data.toJson());

class ProductDetails {
  int? status;
  List<Datum>? data;

  ProductDetails({
    this.status,
    this.data,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
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
  bool? availableInPos;
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
  List<ProductCategory>? productCategories;
  List<Extra>? extras;
  String? image;
  double? virtualAvailable;
  double? qtyAvailable;
  List<int>? taxesId;
  String? taxesName;

  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.defaultCode,
    this.listPrice,
    this.description,
    this.descriptionAr,
    this.availableInPos,
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
    this.productCategories,
    this.extras,
    this.image,
    this.virtualAvailable,
    this.qtyAvailable,
    this.taxesId,
    this.taxesName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      id: json["id"],
      name: json["name"],
      nameAr: json["name_ar"],
      defaultCode: json["default_code"],
      listPrice: json["list_price"]?.toDouble(),
      description: json["description"],
      descriptionAr: json["description_ar"],
      availableInPos: json["available_in_pos"],
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
      productCategories: json["product_categories"] == null
          ? []
          : List<ProductCategory>.from(json["product_categories"]!.map((x) => ProductCategory.fromJson(x))),
      extras: json["extras"] == null ? [] : List<Extra>.from(json["extras"]!.map((x) => Extra.fromJson(x))),
      image: json["image"],
      virtualAvailable: json["virtual_available"],
      qtyAvailable: json["qty_available"],
      taxesId: json["taxes_id"] == null ? [] : List<int>.from(json["taxes_id"]!.map((x) => x)),
      taxesName: json["taxes_name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "default_code": defaultCode,
        "list_price": listPrice,
        "description": description,
        "description_ar": descriptionAr,
        "available_in_pos": availableInPos,
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
        "product_categories": productCategories == null ? [] : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        "extras": extras == null ? [] : List<dynamic>.from(extras!.map((x) => x.toJson())),
        "image": image,
        "virtual_available": virtualAvailable,
        "qty_available": qtyAvailable,
        "taxes_id": taxesId == null ? [] : List<dynamic>.from(taxesId!.map((x) => x)),
      };
}

class Extra {
  int? id;
  int? productId;
  int? variantProductId;
  String? name;
  String? nameAr;
  double? listPrice;
  double? calories;
  bool? isVariant;
  bool? small;
  bool? medium;
  bool? large;
  double? smallPrice;
  double? mediumPrice;
  double? largePrice;
  bool? active;
  bool? isPublished;
  bool? isArchived;
  List<int>? taxesId;

  Extra({
    this.id,
    this.productId,
    this.variantProductId,
    this.name,
    this.nameAr,
    this.listPrice,
    this.calories,
    this.isVariant,
    this.small,
    this.medium,
    this.large,
    this.smallPrice,
    this.mediumPrice,
    this.largePrice,
    this.active,
    this.isPublished,
    this.isArchived,
    this.taxesId,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        id: json["id"],
        productId: json["product_id"],
        variantProductId: json["variant_product_id"],
        name: json["name"],
        nameAr: json["name_ar"],
        listPrice: json["list_price"],
        calories: json["calories"],
        isVariant: json["is_variant"],
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
        smallPrice: json["small_price"],
        mediumPrice: json["medium_price"],
        largePrice: json["large_price"],
        active: json["active"],
        isPublished: json["is_published"],
        isArchived: json["is_archived"],
        taxesId: json["taxes_id"] == null ? [] : List<int>.from(json["taxes_id"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "variant_product_id": variantProductId,
        "name": name,
        "name_ar": nameAr,
        "list_price": listPrice,
        "calories": calories,
        "is_variant": isVariant,
        "small": small,
        "medium": medium,
        "large": large,
        "small_price": smallPrice,
        "medium_price": mediumPrice,
        "large_price": largePrice,
        "active": active,
        "is_published": isPublished,
        "is_archived": isArchived,
      };
}

class ProductCategory {
  int? categoryId;
  String? categoryName;
  String? categoryNameAr;

  ProductCategory({
    this.categoryId,
    this.categoryName,
    this.categoryNameAr,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryNameAr: json["category_name_ar"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_name_ar": categoryNameAr,
      };
}
