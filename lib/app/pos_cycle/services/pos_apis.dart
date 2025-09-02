import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/add_delivery_user.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/check_out.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/generate_delivery_payment.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/register_delivery_payment.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/add_pos_model.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_kiosk_orders.dart' as allkiosk;
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_pos.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_users.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/available_payment_methods.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/close_pos_session_data.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/closing_session_repost_model.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/current_session.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/discount_model.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/draft_refund_order.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/open_pos_session.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/pos_sessions.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/refund_order_payment.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/reverse_refund_order.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/search_by_receipt.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/status_msg_model.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/services/dio_client.dart';
import 'package:provider/provider.dart';

import '../models/status_msg_model.dart';

class PosApis {
  static const int _maxRetries = 20;
  static const Duration _retryDelay = Duration(seconds: 1);

  /// Generic helper for retrying requests on status 500
  // Future<T?> _retryRequest<T>(Future<Response> Function() request, T Function(dynamic data) parser, {int retryCount = 0}) async {
  //   try {
  //     final response = await request();

  //     if (response.statusCode == 200) {
  //       return parser(response.data);
  //     } else if (response.statusCode == 500 && retryCount < _maxRetries) {
  //       await Future.delayed(_retryDelay);
  //       return _retryRequest(request, parser, retryCount: retryCount + 1);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     if (retryCount < _maxRetries) {
  //       await Future.delayed(_retryDelay);
  //       return _retryRequest(request, parser, retryCount: retryCount + 1);
  //     } else {
  //       print('API error after $_maxRetries retries >> $e');
  //       return null;
  //     }
  //   }
  // }

  Future<T?> _retryRequest<T>(
    Future<Response> Function() request,
    T Function(dynamic data) parser, {
    int retryCount = 0,
    bool debugPrintResponse = false,
  }) async {
    try {
      final response = await request();

      if (debugPrintResponse) {
        print('API Response [${response.statusCode}]: ${response.data}');
      }

      if (response.statusCode == 200) {
        return parser(response.data);
      } else if (response.statusCode == 500 && retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _retryRequest(
          request,
          parser,
          retryCount: retryCount + 1,
          debugPrintResponse: debugPrintResponse,
        );
      } else {
        return null;
      }
    } catch (e) {
      // if using Dio, you may want to check for DioError to print response.data
      if (debugPrintResponse) {
        if (e is DioException && e.response != null) {
          print('API Error Response [${e.response?.statusCode}]: ${e.response?.data}');
        } else {
          print('API Exception: $e');
        }
      }

      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _retryRequest(
          request,
          parser,
          retryCount: retryCount + 1,
          debugPrintResponse: debugPrintResponse,
        );
      } else {
        print('API error after $_maxRetries retries >> $e');
        return null;
      }
    }
  }

  Future<AllPos?> getAllPos() async {
    return _retryRequest(() => Client.client.get('http://157.180.26.238:10000/get_all_pos'), (data) => AllPos.fromJson(data));
  }

  Future<StatusMsgModel?> editPosName(String name, int posId) async {
    return _retryRequest(
      () => Client.client.post('http://157.180.26.238:10000/edit_pos', data: {"pos_id": posId, "name": name}),
      (data) => StatusMsgModel.fromJson(data),
    );
  }

  Future<PosSessions?> getPosSessions(int posId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_pos_sessions/$posId'),
      (data) => PosSessions.fromJson(data),
    );
  }

  Future<StatusMsgModel?> archivePOS(int posId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/archive_pos/$posId'),
      (data) => StatusMsgModel.fromJson(data),
    );
  }

  Future<AddPosModel?> addNewPos(String posName) async {
    return _retryRequest(
      () => Client.client.post('http://157.180.26.238:10000/new_pos', data: {"name": posName, "currency_id": 74}),
      (data) => AddPosModel.fromJson(data),
    );
  }

  Future<OpenPosSession?> openNewPosSession(
    int posId,
    int cashierId,
    int currencyId,
    double openingBalance,
    String openingNote,
  ) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/open_pos_session',
        data: {
          "pos_id": posId,
          "cashier_id": cashierId,
          "currency_id": 74,
          "opening_balance": openingBalance,
          "opening_notes": openingNote,
        },
      ),
      (data) => OpenPosSession.fromJson(data),
    );
  }

  Future<CurrentSession?> getCurrentSessionData(int posId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_pos_latest_session/$posId'),
      (data) => CurrentSession.fromJson(data),
    );
  }

  Future<AvailablePaymentMethods?> getAvailablePaymentMethods() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_all_pos_payment_methods'),
      (data) => AvailablePaymentMethods.fromJson(data),
    );
  }

  Future<CheckOut?> finishOrder(
    int sessionId,
    int paymentMethodId,
    int cashierId,
    int customerId,
    bool isTipped,
    double tipAmount,
    List<CartLineItem> cartLines,
    int deliveryUserId,
    BuildContext context,
  ) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/finalize_order',
        data: {
          "session_id": sessionId,
          "payment_method_id": paymentMethodId,
          "cashier_id": cashierId,
          "customer_id": customerId,
          "is_tipped": isTipped,
          "tip_amount": tipAmount,
          "products": [
            for (var item in cartLines)
              {
                "product_id": item.productId,
                "qty": item.quantity,
                "price_unit": item.priceUnit,
                "discount": item.discount,
                "tax_ids": item.taxIds,
                "price_subtotal": item.priceSubtotalWithoutTax,
                "price_subtotal_incl": item.priceWithTax,
                "full_product_name": item.productName,
                "customer_note": item.customerNote,
                "kitchen_note": item.kitchenNote,
                "price_type": item.priceType,
              },
          ],
          "res_delivery_id": deliveryUserId,
          "to_invoice": deliveryUserId == 0,
          "is_kiosk": false,
          "customer_name": context.read<MenuProvider>().customerData["customerName"],
          "customer_phone": context.read<MenuProvider>().customerData["customerPhone"],
          "waiter_name": context.read<MenuProvider>().customerData["waiterName"],
        },
      ),
      (data) => CheckOut.fromJson(data),
    );
  }

  Future<CheckOut?> finishOrderForKioskOrder(
    int sessionId,
    int paymentMethodId,
    int cashierId,
    int customerId,
    bool isTipped,
    double tipAmount,
    List<allkiosk.OrderLine> cartLines,
    int deliveryUserId,
    BuildContext context,
  ) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/finalize_order',
        data: {
          "session_id": sessionId,
          "payment_method_id": paymentMethodId,
          "cashier_id": cashierId,
          "customer_id": customerId,
          "is_tipped": isTipped,
          "tip_amount": tipAmount,
          "products": [
            for (var item in cartLines)
              {
                "product_id": item.productId,
                "qty": item.qty,
                "price_unit": item.priceUnit,
                "discount": item.discount,
                "tax_ids": item.taxIds == 0 ? [] : [item.taxIds],
                "price_subtotal": item.priceSubtotal,
                "price_subtotal_incl": item.priceSubtotalIncl,
                "full_product_name": item.fullProductName,
                "customer_note": item.customerNote,
                "kitchen_note": item.kitchenNote,
                "price_type": item.priceType,
              },
          ],
          "res_delivery_id": deliveryUserId,
          "to_invoice": deliveryUserId == 0,
          "is_kiosk": true,
          "customer_name": "",
          "customer_phone": "",
          "waiter_name": "",
        },
      ),
      (data) => CheckOut.fromJson(data),
    );
  }

  Future<StatusMsgModel?> processKioskOrder(int orderId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/process_kiosk_order/$orderId'),
      (data) => StatusMsgModel.fromJson(data),
    );
  }

  Future<DeliveryUsers?> getAllUsers() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_all_res_delivery'),
      (data) => DeliveryUsers.fromJson(data),
    );
  }

  Future<DeliveryUsers?> getDeliveryUserById(int userId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_res_delivery_by_id/$userId'),
      (data) => DeliveryUsers.fromJson(data),
    );
  }

  Future<DeliveryUsers?> getDeliveryUserByNumber(String phoneNumber) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_res_delivery_by_phone/$phoneNumber'),
      (data) => DeliveryUsers.fromJson(data),
    );
  }

  Future<AddDeliveryUser?> addDeliveryUser(String userName, String userPhone, String userAddress) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/new_res_delivery',
        data: {"name": userName, "phone": userPhone, "address": userAddress},
      ),
      (data) => AddDeliveryUser.fromJson(data),
    );
  }

  Future<StatusMsgModel?> closeSession(int sessionId, double closingCash, String closingNotes) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/close_pos_session',
        data: {"session_id": sessionId, "closing_cash": closingCash, "notes": closingNotes},
      ),
      (data) => StatusMsgModel.fromJson(data),
    );
  }

  Future<AllSessionOrders?> getAllSessionOrders(int sessionId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_session_orders/$sessionId'),
      (data) => AllSessionOrders.fromJson(data),
    );
  }

  Future<RegisterDeliveryPayment?> generateAndRegisterDeliveryOrder(int orderId, int journalId) async {
    return _retryRequest(() async {
      final response = await Client.client.get('http://157.180.26.238:10000/generate_delivery_order_invoice/$orderId');

      if (response.statusCode == 200) {
        final generateDeliveryPayment = GenerateDeliveryPayment.fromJson(response.data);
        if (generateDeliveryPayment.status == 1) {
          return await Client.client.post(
            'http://157.180.26.238:10000/register_delivery_order_payment',
            data: {"invoice_id": generateDeliveryPayment.invoiceId, "journal_id": journalId},
          );
        }
      }
      return response;
    }, (data) => RegisterDeliveryPayment.fromJson(data));
  }

  Future<ClosingSessionData?> getClosingSessionData(int sessionId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_session_closing_data/$sessionId'),
      (data) => ClosingSessionData.fromJson(data),
    );
  }

  Future<DraftRefundOrder?> draftRefundOrderFirst(int orderId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/draft_refund_order/$orderId'),
      (data) => DraftRefundOrder.fromJson(data),
    );
  }

  Future<RefundOrderPayment?> refundOrderPaymentSecond(int posId, int sessionId, int refundOrderId) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/refund_order_payment',
        data: {"pos_id": posId, "session_id": sessionId, "refund_order_id": refundOrderId},
      ),
      (data) => RefundOrderPayment.fromJson(data),
    );
  }

  Future<ReverseRefundOrder?> reverseRefundOrderInvoiceThird(int posId, int sessionId, int refundOrderId) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/reverse_refund_order_invoice',
        data: {"pos_id": posId, "session_id": sessionId, "refund_order_id": refundOrderId},
      ),
      (data) => ReverseRefundOrder.fromJson(data),
    );
  }

  Future<SearchByReceipt?> searchOrderByReceipt(String receiptNumber) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/search_order_receipt/$receiptNumber'),
      (data) => SearchByReceipt.fromJson(data),
    );
  }

  Future<allkiosk.AllKioskOrders?> getAllKioskOrders(int sessionId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_session_all_kiosk_orders/$sessionId'),
      (data) => allkiosk.AllKioskOrders.fromJson(data),
    );
  }

  Future<DiscountModel?> getDiscountData() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_pos_discount_product'),
      (data) => DiscountModel.fromJson(data),
    );
  }

  Future<int?> getCustomerID() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_customer_account'),
      (data) => data['data'] as int,
    );
  }

  Future<ClosingSessionReport?> getClosingSessionReport(int sessionId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_session_closing_report/$sessionId'),
      (data) => ClosingSessionReport.fromJson(data),
    );
  }

  Future<StatusMsgModel?> addClientUniqueID(String deviceId) async {
    return _retryRequest(
      () => Client.client.post(
        'http://157.180.26.238:10000/set_client_unique_id',
        data: {"dummy": "string", "unique_id": deviceId},
      ),
      (data) => StatusMsgModel.fromJson(data),
    );
  }
}
