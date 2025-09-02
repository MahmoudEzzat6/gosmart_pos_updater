// To parse this JSON data, do
//
//     final allProducts = allProductsFromJson(jsonString);

import 'dart:convert';

AllProducts allProductsFromJson(String str) => AllProducts.fromJson(json.decode(str));

String allProductsToJson(AllProducts data) => json.encode(data.toJson());

class AllProducts {
  int? status;
  List<Datum>? data;

  AllProducts({
    this.status,
    this.data,
  });

  factory AllProducts.fromJson(Map<String, dynamic> json) => AllProducts(
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
  String? barcode;
  double? listPrice;
  String? description;
  String? descriptionAr;
  bool? availableInPos;
  bool? active;
  bool? isPublished;
  bool? isArchived;
  double? calories;
  bool? isVariant;
  bool? small;
  double? smallPrice;
  bool? medium;
  double? mediumPrice;
  bool? large;
  double? largePrice;
  List<ProductCategory>? productCategories;
  List<Extra>? extras;
  double? virtualAvailable;
  double? qtyAvailable;
  String? image;
  List<int>? taxesId;

  Datum({
    this.id,
    this.name,
    this.nameAr,
    this.defaultCode,
    this.barcode,
    this.listPrice,
    this.description,
    this.descriptionAr,
    this.availableInPos,
    this.active,
    this.isPublished,
    this.isArchived,
    this.calories,
    this.isVariant,
    this.small,
    this.smallPrice,
    this.medium,
    this.mediumPrice,
    this.large,
    this.largePrice,
    this.productCategories,
    this.extras,
    this.virtualAvailable,
    this.qtyAvailable,
    this.image,
    this.taxesId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        defaultCode: json["default_code"],
        barcode: json["barcode"],
        listPrice: json["list_price"]?.toDouble(),
        description: json["description"],
        descriptionAr: json["description_ar"],
        availableInPos: json["available_in_pos"],
        active: json["active"],
        isPublished: json["is_published"],
        isArchived: json["is_archived"],
        calories: json["calories"],
        isVariant: json["is_variant"],
        small: json["small"],
        smallPrice: json["small_price"]?.toDouble(),
        medium: json["medium"],
        mediumPrice: json["medium_price"]?.toDouble(),
        large: json["large"],
        largePrice: json["large_price"]?.toDouble(),
        productCategories: json["product_categories"] == null
            ? []
            : List<ProductCategory>.from(json["product_categories"]!.map((x) => ProductCategory.fromJson(x))),
        extras: json["extras"] == null ? [] : List<Extra>.from(json["extras"]!.map((x) => Extra.fromJson(x))),
        virtualAvailable: json["virtual_available"],
        qtyAvailable: json["qty_available"],
        image: json["image"],
        taxesId: json["taxes_id"] == null ? [] : List<int>.from(json["taxes_id"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_ar": nameAr,
        "default_code": defaultCode,
        "barcode": barcode,
        "list_price": listPrice,
        "description": description,
        "description_ar": descriptionAr,
        "available_in_pos": availableInPos,
        "active": active,
        "is_published": isPublished,
        "is_archived": isArchived,
        "calories": calories,
        "is_variant": isVariant,
        "small": small,
        "small_price": smallPrice,
        "medium": medium,
        "medium_price": mediumPrice,
        "large": large,
        "large_price": largePrice,
        "product_categories": productCategories == null ? [] : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        "extras": extras == null ? [] : List<dynamic>.from(extras!.map((x) => x.toJson())),
        "virtual_available": virtualAvailable,
        "qty_available": qtyAvailable,
        "image": image,
      };
}

class Extra {
  int? id;
  int? productId;
  int? variantProductId;
  String? name;
  String? nameAr;
  double? listPrice;
  String? barcode;
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
  List<dynamic>? taxesId;

  Extra({
    this.id,
    this.productId,
    this.variantProductId,
    this.name,
    this.nameAr,
    this.listPrice,
    this.barcode,
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
        barcode: json["barcode"],
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
        taxesId: json["taxes_id"] == null ? [] : List<dynamic>.from(json["taxes_id"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "variant_product_id": variantProductId,
        "name": name,
        "name_ar": nameAr,
        "list_price": listPrice,
        "barcode": barcode,
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
        "taxes_id": taxesId == null ? [] : List<dynamic>.from(taxesId!.map((x) => x)),
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
