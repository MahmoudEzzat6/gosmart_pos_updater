// To parse this JSON data, do
//
//     final generateDeliveryPayment = generateDeliveryPaymentFromJson(jsonString);

import 'dart:convert';

GenerateDeliveryPayment generateDeliveryPaymentFromJson(String str) => GenerateDeliveryPayment.fromJson(json.decode(str));

String generateDeliveryPaymentToJson(GenerateDeliveryPayment data) => json.encode(data.toJson());

class GenerateDeliveryPayment {
  int? status;
  String? message;
  String? messageAr;
  int? invoiceId;

  GenerateDeliveryPayment({
    this.status,
    this.message,
    this.messageAr,
    this.invoiceId,
  });

  factory GenerateDeliveryPayment.fromJson(Map<String, dynamic> json) => GenerateDeliveryPayment(
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
