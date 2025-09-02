// To parse this JSON data, do
//
//     final closingSessionReport = closingSessionReportFromJson(jsonString);

import 'dart:convert';

ClosingSessionReport closingSessionReportFromJson(String str) => ClosingSessionReport.fromJson(json.decode(str));

String closingSessionReportToJson(ClosingSessionReport data) => json.encode(data.toJson());

class ClosingSessionReport {
  dynamic sessionId;
  Orders? finishedOrders;
  Orders? deliveryOrders;
  RefundedOrders? refundedOrders;

  ClosingSessionReport({
    this.sessionId,
    this.finishedOrders,
    this.deliveryOrders,
    this.refundedOrders,
  });

  factory ClosingSessionReport.fromJson(Map<String, dynamic> json) => ClosingSessionReport(
        sessionId: json["session_id"],
        finishedOrders: json["finished_orders"] == null ? null : Orders.fromJson(json["finished_orders"]),
        deliveryOrders: json["delivery_orders"] == null ? null : Orders.fromJson(json["delivery_orders"]),
        refundedOrders: json["refunded_orders"] == null ? null : RefundedOrders.fromJson(json["refunded_orders"]),
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "finished_orders": finishedOrders?.toJson(),
        "delivery_orders": deliveryOrders?.toJson(),
        "refunded_orders": refundedOrders?.toJson(),
      };
}

class Orders {
  List<Category>? categories;
  dynamic grandTotal;

  Orders({
    this.categories,
    this.grandTotal,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        grandTotal: json["grand_total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "grand_total": grandTotal,
      };
}

class Category {
  dynamic categoryId;
  String? categoryName;
  String? categoryNameAr;
  dynamic total;
  List<Product>? products;

  Category({
    this.categoryId,
    this.categoryName,
    this.categoryNameAr,
    this.total,
    this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryNameAr: json["category_name_ar"],
        total: json["total"]?.toDouble(),
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_name_ar": categoryNameAr,
        "total": total,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  dynamic productId;
  String? name;
  String? nameAr;
  dynamic qty;
  dynamic price;
  dynamic total;

  Product({
    this.productId,
    this.name,
    this.nameAr,
    this.qty,
    this.price,
    this.total,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["product_id"],
        name: json["name"],
        nameAr: json["name_ar"],
        qty: json["qty"],
        price: json["price"]?.toDouble(),
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "name_ar": nameAr,
        "qty": qty,
        "price": price,
        "total": total,
      };
}

class RefundedOrders {
  List<Category>? categories;
  dynamic grandTotal;
  dynamic grandTotalSigned;

  RefundedOrders({
    this.categories,
    this.grandTotal,
    this.grandTotalSigned,
  });

  factory RefundedOrders.fromJson(Map<String, dynamic> json) => RefundedOrders(
        categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
        grandTotal: json["grand_total"]?.toDouble(),
        grandTotalSigned: json["grand_total_signed"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "grand_total": grandTotal,
        "grand_total_signed": grandTotalSigned,
      };
}
