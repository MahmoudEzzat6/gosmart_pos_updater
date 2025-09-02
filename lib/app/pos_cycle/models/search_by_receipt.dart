// To parse this JSON data, do
//
//     final searchByReceipt = searchByReceiptFromJson(jsonString);

import 'dart:convert';

SearchByReceipt searchByReceiptFromJson(String str) => SearchByReceipt.fromJson(json.decode(str));

String searchByReceiptToJson(SearchByReceipt data) => json.encode(data.toJson());

class SearchByReceipt {
  int? status;
  List<Datum>? data;

  SearchByReceipt({
    this.status,
    this.data,
  });

  factory SearchByReceipt.fromJson(Map<String, dynamic> json) => SearchByReceipt(
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
  String? name;
  String? state;
  int? cashierId;
  String? cashier;
  int? customerId;
  String? customerName;
  String? posReference;
  String? ticketCode;
  int? sessionId;
  String? sessionName;
  String? sessionState;
  int? posId;
  String? posName;
  bool? isTipped;
  double? tipAmount;
  DateTime? dateOrder;
  double? amountTax;
  double? amountTotal;
  double? amountPaid;
  double? amountReturn;
  List<OrderLine>? orderLines;
  List<PaymentDatum>? paymentData;
  List<InvoiceDetail>? invoiceDetails;
  String? orderNumber;
  bool? currentPosActiveSessionState;
  int? currentPosActiveSessionId;

  Datum({
    this.currentPosActiveSessionState,
    this.currentPosActiveSessionId,
    this.id,
    this.name,
    this.state,
    this.cashierId,
    this.cashier,
    this.customerId,
    this.customerName,
    this.posReference,
    this.ticketCode,
    this.sessionId,
    this.sessionName,
    this.sessionState,
    this.posId,
    this.posName,
    this.isTipped,
    this.tipAmount,
    this.dateOrder,
    this.amountTax,
    this.amountTotal,
    this.amountPaid,
    this.amountReturn,
    this.orderLines,
    this.paymentData,
    this.invoiceDetails,
    this.orderNumber,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        currentPosActiveSessionId: json["current_pos_active_session_id"],
        currentPosActiveSessionState: json["current_pos_active_session"],
        id: json["id"],
        name: json["name"],
        state: json["state"],
        cashierId: json["cashier_id"],
        cashier: json["cashier"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        posReference: json["pos_reference"],
        ticketCode: json["ticket_code"],
        sessionId: json["session_id"],
        sessionName: json["session_name"],
        sessionState: json["session_state"],
        posId: json["pos_id"],
        posName: json["pos_name"],
        isTipped: json["is_tipped"],
        tipAmount: json["tip_amount"],
        dateOrder: json["date_order"] == null ? null : DateTime.parse(json["date_order"]),
        amountTax: json["amount_tax"],
        amountTotal: json["amount_total"]?.toDouble(),
        amountPaid: json["amount_paid"]?.toDouble(),
        amountReturn: json["amount_return"],
        orderLines:
            json["order_lines"] == null ? [] : List<OrderLine>.from(json["order_lines"]!.map((x) => OrderLine.fromJson(x))),
        paymentData: json["payment_data"] == null
            ? []
            : List<PaymentDatum>.from(json["payment_data"]!.map((x) => PaymentDatum.fromJson(x))),
        invoiceDetails: json["invoice_details"] == null
            ? []
            : List<InvoiceDetail>.from(json["invoice_details"]!.map((x) => InvoiceDetail.fromJson(x))),
        orderNumber: json["order_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state": state,
        "cashier_id": cashierId,
        "cashier": cashier,
        "customer_id": customerId,
        "customer_name": customerName,
        "pos_reference": posReference,
        "ticket_code": ticketCode,
        "session_id": sessionId,
        "session_name": sessionName,
        "session_state": sessionState,
        "pos_id": posId,
        "pos_name": posName,
        "is_tipped": isTipped,
        "tip_amount": tipAmount,
        "date_order": dateOrder?.toIso8601String(),
        "amount_tax": amountTax,
        "amount_total": amountTotal,
        "amount_paid": amountPaid,
        "amount_return": amountReturn,
        "order_lines": orderLines == null ? [] : List<dynamic>.from(orderLines!.map((x) => x.toJson())),
        "payment_data": paymentData == null ? [] : List<dynamic>.from(paymentData!.map((x) => x.toJson())),
        "invoice_details": invoiceDetails == null ? [] : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
        "order_number": orderNumber,
      };
}

class InvoiceDetail {
  int? id;
  String? reference;
  String? orderRef;
  String? state;
  DateTime? date;
  double? untaxedAmount;
  double? taxes;
  double? total;
  double? amountDue;

  InvoiceDetail({
    this.id,
    this.reference,
    this.orderRef,
    this.state,
    this.date,
    this.untaxedAmount,
    this.taxes,
    this.total,
    this.amountDue,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        id: json["id"],
        reference: json["reference"],
        orderRef: json["order_ref"],
        state: json["state"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        untaxedAmount: json["untaxed_amount"]?.toDouble(),
        taxes: json["taxes"],
        total: json["total"]?.toDouble(),
        amountDue: json["amount_due"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference": reference,
        "order_ref": orderRef,
        "state": state,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "untaxed_amount": untaxedAmount,
        "taxes": taxes,
        "total": total,
        "amount_due": amountDue,
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
  String? taxes;
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
    this.taxes,
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
        taxes: json["taxes"],
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
        "taxes": taxes,
        "customer_note": customerNote,
        "kitchen_note": kitchenNote,
      };
}

class PaymentDatum {
  int? id;
  double? amount;
  String? type;
  int? cashJournalId;

  PaymentDatum({
    this.id,
    this.amount,
    this.type,
    this.cashJournalId,
  });

  factory PaymentDatum.fromJson(Map<String, dynamic> json) => PaymentDatum(
        id: json["id"],
        amount: json["amount"]?.toDouble(),
        type: json["type"],
        cashJournalId: json["cash_journal_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "type": type,
        "cash_journal_id": cashJournalId,
      };
}
