// To parse this JSON data, do
//
//     final reverseRefundOrder = reverseRefundOrderFromJson(jsonString);

import 'dart:convert';

ReverseRefundOrder reverseRefundOrderFromJson(String str) => ReverseRefundOrder.fromJson(json.decode(str));

String reverseRefundOrderToJson(ReverseRefundOrder data) => json.encode(data.toJson());

class ReverseRefundOrder {
  int? status;
  String? message;
  String? messageAr;
  int? invoiceId;

  ReverseRefundOrder({
    this.status,
    this.message,
    this.messageAr,
    this.invoiceId,
  });

  factory ReverseRefundOrder.fromJson(Map<String, dynamic> json) => ReverseRefundOrder(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        invoiceId: json["invoice_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "invoice_id": invoiceId,
      };
}
