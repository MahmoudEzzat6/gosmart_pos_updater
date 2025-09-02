// To parse this JSON data, do
//
//     final draftRefundOrder = draftRefundOrderFromJson(jsonString);

import 'dart:convert';

DraftRefundOrder draftRefundOrderFromJson(String str) => DraftRefundOrder.fromJson(json.decode(str));

String draftRefundOrderToJson(DraftRefundOrder data) => json.encode(data.toJson());

class DraftRefundOrder {
  int? status;
  String? message;
  String? messageAr;
  int? refundOrderId;

  DraftRefundOrder({
    this.status,
    this.message,
    this.messageAr,
    this.refundOrderId,
  });

  factory DraftRefundOrder.fromJson(Map<String, dynamic> json) => DraftRefundOrder(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        refundOrderId: json["refund_order_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "refund_order_id": refundOrderId,
      };
}
