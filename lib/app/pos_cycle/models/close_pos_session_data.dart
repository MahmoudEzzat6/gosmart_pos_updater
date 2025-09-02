// To parse this JSON data, do
//
//     final closingSessionData = closingSessionDataFromJson(jsonString);

import 'dart:convert';

ClosingSessionData closingSessionDataFromJson(String str) => ClosingSessionData.fromJson(json.decode(str));

String closingSessionDataToJson(ClosingSessionData data) => json.encode(data.toJson());

class ClosingSessionData {
  dynamic status;
  Data? data;

  ClosingSessionData({
    this.status,
    this.data,
  });

  factory ClosingSessionData.fromJson(Map<String, dynamic> json) => ClosingSessionData(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  String? openingNotes;
  OrdersDetails? ordersDetails;
  CashDetails? cashDetails;
  List<OtherPaymentMethod>? otherPaymentMethods;

  Data({
    this.openingNotes,
    this.ordersDetails,
    this.cashDetails,
    this.otherPaymentMethods,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        openingNotes: json["opening_notes"],
        ordersDetails: json["orders_details"] == null ? null : OrdersDetails.fromJson(json["orders_details"]),
        cashDetails: json["cash_details"] == null ? null : CashDetails.fromJson(json["cash_details"]),
        otherPaymentMethods: json["other_payment_methods"] == null
            ? []
            : List<OtherPaymentMethod>.from(json["other_payment_methods"]!.map((x) => OtherPaymentMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "opening_notes": openingNotes,
        "orders_details": ordersDetails?.toJson(),
        "cash_details": cashDetails?.toJson(),
        "other_payment_methods":
            otherPaymentMethods == null ? [] : List<dynamic>.from(otherPaymentMethods!.map((x) => x.toJson())),
      };
}

class CashDetails {
  dynamic id;
  String? name;
  dynamic opening;
  dynamic paymentAmount;
  dynamic cashAmountDue;
  List<Move>? moves;

  CashDetails({
    this.id,
    this.name,
    this.opening,
    this.paymentAmount,
    this.cashAmountDue,
    this.moves,
  });

  factory CashDetails.fromJson(Map<String, dynamic> json) => CashDetails(
        id: json["id"],
        name: json["name"],
        opening: json["opening"],
        paymentAmount: json["payment_amount"],
        cashAmountDue: json["cash_amount_due"],
        moves: json["moves"] == null ? [] : List<Move>.from(json["moves"]!.map((x) => Move.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "opening": opening,
        "payment_amount": paymentAmount,
        "cash_amount_due": cashAmountDue,
        "moves": moves == null ? [] : List<dynamic>.from(moves!.map((x) => x.toJson())),
      };
}

class Move {
  String? name;
  dynamic amount;

  Move({
    this.name,
    this.amount,
  });

  factory Move.fromJson(Map<String, dynamic> json) => Move(
        name: json["name"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
      };
}

class OrdersDetails {
  dynamic quantity;
  dynamic amountTotal;

  OrdersDetails({
    this.quantity,
    this.amountTotal,
  });

  factory OrdersDetails.fromJson(Map<String, dynamic> json) => OrdersDetails(
        quantity: json["quantity"],
        amountTotal: json["amount_total"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "amount_total": amountTotal,
      };
}

class OtherPaymentMethod {
  dynamic id;
  String? type;
  String? name;
  dynamic totalAmount;
  dynamic numberOfOrders;

  OtherPaymentMethod({
    this.id,
    this.type,
    this.name,
    this.totalAmount,
    this.numberOfOrders,
  });

  factory OtherPaymentMethod.fromJson(Map<String, dynamic> json) => OtherPaymentMethod(
        id: json["id"],
        type: json["type"],
        name: json["name"],
        totalAmount: json["total_amount"],
        numberOfOrders: json["number_of_orders"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "name": name,
        "total_amount": totalAmount,
        "number_of_orders": numberOfOrders,
      };
}
