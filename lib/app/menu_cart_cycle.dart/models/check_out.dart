// To parse this JSON data, do
//
//     final checkOut = checkOutFromJson(jsonString);

import 'dart:convert';

CheckOut checkOutFromJson(String str) => CheckOut.fromJson(json.decode(str));

String checkOutToJson(CheckOut data) => json.encode(data.toJson());

class CheckOut {
  int? status;
  String? message;
  String? messageAr;
  Result? result;

  CheckOut({
    this.status,
    this.message,
    this.messageAr,
    this.result,
  });

  factory CheckOut.fromJson(Map<String, dynamic> json) => CheckOut(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "result": result?.toJson(),
      };
}

class Result {
  int? orderId;
  String? orderRef;
  String? receiptNumber;
  String? orderNumber;
  int? invoiceId;
  String? invoiceRef;

  Result({
    this.orderId,
    this.orderRef,
    this.receiptNumber,
    this.orderNumber,
    this.invoiceId,
    this.invoiceRef,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        orderId: json["order_id"],
        orderRef: json["order_ref"],
        receiptNumber: json["receipt_number"],
        orderNumber: json["order_number"],
        invoiceId: json["invoice_id"],
        invoiceRef: json["invoice_ref"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_ref": orderRef,
        "receipt_number": receiptNumber,
        "order_number": orderNumber,
        "invoice_id": invoiceId,
        "invoice_ref": invoiceRef,
      };
}
