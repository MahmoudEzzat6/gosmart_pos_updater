// To parse this JSON data, do
//
//     final refundOrderPayment = refundOrderPaymentFromJson(jsonString);

import 'dart:convert';

RefundOrderPayment refundOrderPaymentFromJson(String str) => RefundOrderPayment.fromJson(json.decode(str));

String refundOrderPaymentToJson(RefundOrderPayment data) => json.encode(data.toJson());

class RefundOrderPayment {
  int? status;
  String? message;
  String? messageAr;
  int? paymentWizardId;
  Result? result;

  RefundOrderPayment({
    this.status,
    this.message,
    this.messageAr,
    this.paymentWizardId,
    this.result,
  });

  factory RefundOrderPayment.fromJson(Map<String, dynamic> json) => RefundOrderPayment(
        status: json["status"],
        message: json["message"],
        messageAr: json["message_ar"],
        paymentWizardId: json["payment_wizard_id"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "message_ar": messageAr,
        "payment_wizard_id": paymentWizardId,
        "result": result?.toJson(),
      };
}

class Result {
  String? type;

  Result({
    this.type,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
