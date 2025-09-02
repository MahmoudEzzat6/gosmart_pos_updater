// To parse this JSON data, do
//
//     final variants = variantsFromJson(jsonString);

import 'dart:convert';

Variants variantsFromJson(String str) => Variants.fromJson(json.decode(str));

String variantsToJson(Variants data) => json.encode(data.toJson());

class Variants {
    int? status;
    List<Variant>? variants;

    Variants({
        this.status,
        this.variants,
    });

    factory Variants.fromJson(Map<String, dynamic> json) => Variants(
        status: json["status"],
        variants: json["variants"] == null ? [] : List<Variant>.from(json["variants"]!.map((x) => Variant.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "variants": variants == null ? [] : List<dynamic>.from(variants!.map((x) => x.toJson())),
    };
}

class Variant {
    int? id;
    String? name;
    String? nameAr;
    String? defaultCode;
    int? listPrice;
    String? description;
    String? descriptionAr;
    int? categId;
    String? categoryName;
    bool? active;
    bool? isPublished;
    bool? isArchived;
    bool? isVariant;
    bool? small;
    int? smallPrice;
    bool? medium;
    int? mediumPrice;
    bool? large;
    int? largePrice;
    int? calories;

    Variant({
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
    });

    factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        id: json["id"],
        name: json["name"],
        nameAr: json["name_ar"],
        defaultCode: json["default_code"],
        listPrice: json["list_price"],
        description: json["description"],
        descriptionAr: json["description_ar"],
        categId: json["categ_id"],
        categoryName: json["category_name"],
        active: json["active"],
        isPublished: json["is_published"],
        isArchived: json["is_archived"],
        isVariant: json["is_variant"],
        small: json["small"],
        smallPrice: json["small_price"],
        medium: json["medium"],
        mediumPrice: json["medium_price"],
        large: json["large"],
        largePrice: json["large_price"],
        calories: json["calories"],
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
    };
}
