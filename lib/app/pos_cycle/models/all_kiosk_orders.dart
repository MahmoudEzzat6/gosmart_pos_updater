// To parse this JSON data, do
//
//     final allKioskOrders = allKioskOrdersFromJson(jsonString);

import 'dart:convert';

AllKioskOrders allKioskOrdersFromJson(String str) => AllKioskOrders.fromJson(json.decode(str));

String allKioskOrdersToJson(AllKioskOrders data) => json.encode(data.toJson());

class AllKioskOrders {
  int? status;
  List<Datum>? data;

  AllKioskOrders({
    this.status,
    this.data,
  });

  factory AllKioskOrders.fromJson(Map<String, dynamic> json) => AllKioskOrders(
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
  int? sessionId;
  int? paymentMethodId;
  int? cashierId;
  int? customerId;
  int? resDeliveryId;
  bool? toInvoice;
  bool? processedOrder;
  List<OrderLine>? orderLines;
  double? cartTotal;

  Datum({
    this.id,
    this.sessionId,
    this.paymentMethodId,
    this.cashierId,
    this.customerId,
    this.resDeliveryId,
    this.toInvoice,
    this.processedOrder,
    this.orderLines,
    this.cartTotal,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sessionId: json["session_id"],
        paymentMethodId: json["payment_method_id"],
        cashierId: json["cashier_id"],
        customerId: json["customer_id"],
        resDeliveryId: json["res_delivery_id"],
        toInvoice: json["to_invoice"],
        processedOrder: json["processed_order"],
        cartTotal: json["cart_total"],
        orderLines:
            json["order_lines"] == null ? [] : List<OrderLine>.from(json["order_lines"]!.map((x) => OrderLine.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "session_id": sessionId,
        "payment_method_id": paymentMethodId,
        "cashier_id": cashierId,
        "customer_id": customerId,
        "res_delivery_id": resDeliveryId,
        "to_invoice": toInvoice,
        "processed_order": processedOrder,
        "order_lines": orderLines == null ? [] : List<dynamic>.from(orderLines!.map((x) => x.toJson())),
      };
}

class OrderLine {
  int? id;
  int? orderId;
  int? productId;
  String? fullProductName;
  double? priceUnit;
  double? qty;
  double? priceSubtotal;
  double? priceSubtotalIncl;
  double? discount;
  int? taxIds;
  String? priceType;
  String? customerNote;
  String? kitchenNote;

  OrderLine({
    this.id,
    this.orderId,
    this.productId,
    this.fullProductName,
    this.priceUnit,
    this.qty,
    this.priceSubtotal,
    this.priceSubtotalIncl,
    this.discount,
    this.taxIds,
    this.priceType,
    this.customerNote,
    this.kitchenNote,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) => OrderLine(
        id: json["id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        fullProductName: json["full_product_name"],
        priceUnit: json["price_unit"]?.toDouble(),
        qty: json["qty"],
        priceSubtotal: json["price_subtotal"]?.toDouble(),
        priceSubtotalIncl: json["price_subtotal_incl"]?.toDouble(),
        discount: json["discount"],
        taxIds: json["tax_ids"],
        priceType: json["price_type"],
        customerNote: json["customer_note"],
        kitchenNote: json["kitchen_note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "product_id": productId,
        "full_product_name": fullProductName,
        "price_unit": priceUnit,
        "qty": qty,
        "price_subtotal": priceSubtotal,
        "price_subtotal_incl": priceSubtotalIncl,
        "discount": discount,
        "tax_ids": taxIds,
        "price_type": priceType,
        "customer_note": customerNote,
        "kitchen_note": kitchenNote,
      };
}
