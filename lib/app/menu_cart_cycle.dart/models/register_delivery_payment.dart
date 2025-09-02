// To parse this JSON data, do
//
//     final registerDeliveryPayment = registerDeliveryPaymentFromJson(jsonString);

import 'dart:convert';

RegisterDeliveryPayment registerDeliveryPaymentFromJson(String str) => RegisterDeliveryPayment.fromJson(json.decode(str));

String registerDeliveryPaymentToJson(RegisterDeliveryPayment data) => json.encode(data.toJson());

class RegisterDeliveryPayment {
  int? status;
  String? message;
  String? messageAr;
  int? paymentWizardId;
  Result? result;

  RegisterDeliveryPayment({
    this.status,
    this.message,
    this.messageAr,
    this.paymentWizardId,
    this.result,
  });

  factory RegisterDeliveryPayment.fromJson(Map<String, dynamic> json) => RegisterDeliveryPayment(
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
  String? name;
  String? type;
  String? resModel;
  Context? context;
  String? viewMode;
  int? resId;

  Result({
    this.name,
    this.type,
    this.resModel,
    this.context,
    this.viewMode,
    this.resId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        type: json["type"],
        resModel: json["res_model"],
        context: json["context"] == null ? null : Context.fromJson(json["context"]),
        viewMode: json["view_mode"],
        resId: json["res_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "res_model": resModel,
        "context": context?.toJson(),
        "view_mode": viewMode,
        "res_id": resId,
      };
}

class Context {
  bool? create;

  Context({
    this.create,
  });

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        create: json["create"],
      );

  Map<String, dynamic> toJson() => {
        "create": create,
      };
}
