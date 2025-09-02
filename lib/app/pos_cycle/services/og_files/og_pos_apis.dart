// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/add_delivery_user.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/check_out.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/generate_delivery_payment.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/register_delivery_payment.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/add_pos_model.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_kiosk_orders.dart' as allkiosk;
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_pos.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_users.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/available_payment_methods.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/close_pos_session_data.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/current_session.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/discount_model.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/draft_refund_order.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/open_pos_session.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/pos_sessions.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/refund_order_payment.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/reverse_refund_order.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/search_by_receipt.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/models/status_msg_model.dart';
// import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
// import 'package:pos_windows_ice_hub/services/dio_client.dart';
// import 'package:provider/provider.dart';

// class PosApis {
//   Future<AllPos?> getAllPos() async {
//     String url = 'http://157.180.26.238:10000/get_all_pos';

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         AllPos allPos = AllPos.fromJson(response.data);
//         return allPos;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getAllPos error >>$e';
//     }
//   }

//   Future<StatusMsgModel?> editPosName(String name, int posId) async {
//     String url = 'http://157.180.26.238:10000/edit_pos';

//     try {
//       final response = await Client.client.post(url, data: {"pos_id": posId, "name": name});

//       if (response.statusCode == 200) {
//         StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
//         return statusMsgModel;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'editPosName error >>$e';
//     }
//   }

//   Future<PosSessions?> getPosSessions(int posId) async {
//     String url = 'http://157.180.26.238:10000/get_pos_sessions/$posId';

//     print(url);

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         PosSessions posSessions = PosSessions.fromJson(response.data);
//         return posSessions;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getPosSessions >> $e';
//     }
//   }

//   Future<StatusMsgModel?> archivePOS(int posId) async {
//     String url = 'http://157.180.26.238:10000/archive_pos/$posId';

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
//         return statusMsgModel;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'archivePOS error >>$e';
//     }
//   }

//   Future<AddPosModel?> addNewPos(String posName) async {
//     String url = 'http://157.180.26.238:10000/new_pos';

//     try {
//       final response = await Client.client.post(url, data: {"name": posName, "currency_id": 74});

//       if (response.statusCode == 200) {
//         AddPosModel addPosModel = AddPosModel.fromJson(response.data);
//         return addPosModel;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'addNewPos error >> $e';
//     }
//   }

//   Future<OpenPosSession?> openNewPosSession(
//     int posId,
//     int cashierId,
//     int currencyId,
//     double openingBalance,
//     String openingNote,
//   ) async {
//     String url = 'http://157.180.26.238:10000/open_pos_session';

//     log('''
// {
//         "pos_id": $posId,
//         "cashier_id": $cashierId,
//         "currency_id": 74, //TODO currency id
//         "opening_balance": $openingBalance,
//         "opening_notes": $openingNote
//       });

//         ''');

//     try {
//       final response = await Client.client.post(
//         url,
//         data: {
//           "pos_id": posId,
//           "cashier_id": cashierId,
//           "currency_id": 74, //TODO currency id
//           "opening_balance": openingBalance,
//           "opening_notes": openingNote,
//         },
//       );

//       if (response.statusCode == 200) {
//         OpenPosSession openPosSession = OpenPosSession.fromJson(response.data);
//         return openPosSession;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'openPosSession error >> $e';
//     }
//   }

//   // Future<CurrentSession?> getCurrentSessionData(int posId) async {
//   //   String url = 'http://157.180.26.238:10000/get_pos_latest_session/$posId';

//   //   try {
//   //     final response = await Client.client.get(url);

//   //     if (response.statusCode == 200) {
//   //       CurrentSession currentSession = CurrentSession.fromJson(response.data);
//   //       return currentSession;
//   //     } else {
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     throw 'getCurrentSessionData error >> $e';
//   //   }
//   // }

//   // Future<AvailablePaymentMethods?> getAvailablePaymentMethods() async {
//   //   String url = 'http://157.180.26.238:10000/get_all_pos_payment_methods';

//   //   try {
//   //     final response = await Client.client.get(url);
//   //     if (response.statusCode == 200) {
//   //       AvailablePaymentMethods availablePaymentMethods = AvailablePaymentMethods.fromJson(response.data);
//   //       return availablePaymentMethods;
//   //     } else {
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     throw 'getAvailablePaymentMethods error >> $e';
//   //   }
//   // }

//   Future<CurrentSession?> getCurrentSessionData(int posId, {int retryCount = 0}) async {
//     const int maxRetries = 20;
//     const Duration retryDelay = Duration(seconds: 2);
//     String url = 'http://157.180.26.238:10000/get_pos_latest_session/$posId';

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         return CurrentSession.fromJson(response.data);
//       } else if (response.statusCode == 500 && retryCount < maxRetries) {
//         await Future.delayed(retryDelay);
//         return getCurrentSessionData(posId, retryCount: retryCount + 1);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         await Future.delayed(retryDelay);
//         return getCurrentSessionData(posId, retryCount: retryCount + 1);
//       } else {
//         throw 'getCurrentSessionData error after $maxRetries retries >> $e';
//       }
//     }
//   }

//   Future<AvailablePaymentMethods?> getAvailablePaymentMethods({int retryCount = 0}) async {
//     const int maxRetries = 20;
//     const Duration retryDelay = Duration(seconds: 2);
//     String url = 'http://157.180.26.238:10000/get_all_pos_payment_methods';

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         return AvailablePaymentMethods.fromJson(response.data);
//       } else if (response.statusCode == 500 && retryCount < maxRetries) {
//         await Future.delayed(retryDelay);
//         return getAvailablePaymentMethods(retryCount: retryCount + 1);
//       } else {
//         return null;
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         await Future.delayed(retryDelay);
//         return getAvailablePaymentMethods(retryCount: retryCount + 1);
//       } else {
//         throw 'getAvailablePaymentMethods error after $maxRetries retries >> $e';
//       }
//     }
//   }

// //   Future<CheckOut?> finishOrder(
// //     int sessionId,
// //     int paymentMethodId,
// //     int cashierId,
// //     int customerId,
// //     bool isTipped,
// //     double tipAmount,
// //     List<CartLineItem> cartLines,
// //     int deliveryUserId,
// //     BuildContext context,
// //   ) async {
// //     String url = 'http://157.180.26.238:10000/finalize_order';

// //     log('''
// //  {
// //         "session_id": $sessionId,
// //         "payment_method_id": $paymentMethodId,
// //         "cashier_id": $cashierId,
// //         "customer_id": $customerId,
// //         "is_tipped": $isTipped,
// //         "tip_amount": $tipAmount,
// //         "products": [
// //           for (var item in cartLines)
// //             {
// //               "product_id": item.productId,
// //               "qty": item.quantity,
// //               "price_unit": item.priceUnit,
// //               "discount": item.discount,
// //               "tax_ids": item.taxIds,
// //               "price_subtotal": item.priceSubtotalWithoutTax,
// //               "price_subtotal_incl": item.priceWithTax,
// //               "full_product_name": item.productName,
// //               "customer_note": item.customerNote,
// //               "kitchen_note": item.kitchenNote,
// //               "price_type": item.priceType
// //             }
// //         ],
// //         "res_delivery_id": $deliveryUserId
// //          "to_invoice": ${deliveryUserId == 0 ? true : false}
// //       }

// //         ''');

// //     try {
// //       final response = await Client.client.post(
// //         url,
// //         data: {
// //           "session_id": sessionId,
// //           "payment_method_id": paymentMethodId,
// //           "cashier_id": cashierId,
// //           "customer_id": customerId,
// //           "is_tipped": isTipped,
// //           "tip_amount": tipAmount,
// //           "products": [
// //             for (var item in cartLines)
// //               {
// //                 "product_id": item.productId,
// //                 "qty": item.quantity,
// //                 "price_unit": item.priceUnit,
// //                 "discount": item.discount,
// //                 "tax_ids": item.taxIds,
// //                 "price_subtotal": item.priceSubtotalWithoutTax,
// //                 "price_subtotal_incl": item.priceWithTax,
// //                 "full_product_name": item.productName,
// //                 "customer_note": item.customerNote,
// //                 "kitchen_note": item.kitchenNote,
// //                 "price_type": item.priceType,
// //               },
// //           ],
// //           "res_delivery_id": deliveryUserId,
// //           "to_invoice": deliveryUserId == 0 ? true : false,
// //           "is_kiosk": false,
// //           "customer_name": context.read<MenuProvider>().customerData["customerName"],
// //           "customer_phone": context.read<MenuProvider>().customerData["customerPhone"],
// //           "waiter_name": context.read<MenuProvider>().customerData["waiterName"],
// //         },
// //       );
// //       if (response.statusCode == 200) {
// //         print(response.data.toString());

// //         CheckOut checkOut = CheckOut.fromJson(response.data);
// //         return checkOut;
// //       } else {
// //         return null;
// //       }
// //     } catch (e) {
// //       Navigation().closeDialog(context);
// //       //*

// //       log('finishOrder error >> $e');

// //       // throw 'finishOrder error >> $e';
// //       return null;
// //     }
// //   }

//   Future<CheckOut?> finishOrder(
//     int sessionId,
//     int paymentMethodId,
//     int cashierId,
//     int customerId,
//     bool isTipped,
//     double tipAmount,
//     List<CartLineItem> cartLines,
//     int deliveryUserId,
//     BuildContext context, {
//     int retryCount = 0,
//   }) async {
//     const int maxRetries = 20;
//     const Duration retryDelay = Duration(seconds: 2);
//     String url = 'http://157.180.26.238:10000/finalize_order';

//     try {
//       log('''
//     {
//       "session_id": $sessionId,
//       "payment_method_id": $paymentMethodId,
//       "cashier_id": $cashierId,
//       "customer_id": $customerId,
//       "is_tipped": $isTipped,
//       "tip_amount": $tipAmount,
//       "products": [...],
//       "res_delivery_id": $deliveryUserId,
//       "to_invoice": ${deliveryUserId == 0}
//     }
//     ''');

//       final response = await Client.client.post(
//         url,
//         data: {
//           "session_id": sessionId,
//           "payment_method_id": paymentMethodId,
//           "cashier_id": cashierId,
//           "customer_id": customerId,
//           "is_tipped": isTipped,
//           "tip_amount": tipAmount,
//           "products": [
//             for (var item in cartLines)
//               {
//                 "product_id": item.productId,
//                 "qty": item.quantity,
//                 "price_unit": item.priceUnit,
//                 "discount": item.discount,
//                 "tax_ids": item.taxIds,
//                 "price_subtotal": item.priceSubtotalWithoutTax,
//                 "price_subtotal_incl": item.priceWithTax,
//                 "full_product_name": item.productName,
//                 "customer_note": item.customerNote,
//                 "kitchen_note": item.kitchenNote,
//                 "price_type": item.priceType,
//               },
//           ],
//           "res_delivery_id": deliveryUserId,
//           "to_invoice": deliveryUserId == 0 ? true : false,
//           "is_kiosk": false,
//           "customer_name": context.read<MenuProvider>().customerData["customerName"],
//           "customer_phone": context.read<MenuProvider>().customerData["customerPhone"],
//           "waiter_name": context.read<MenuProvider>().customerData["waiterName"],
//         },
//       );

//       if (response.statusCode == 200) {
//         print(response.data.toString());
//         return CheckOut.fromJson(response.data);
//       } else if (response.statusCode == 500 && retryCount < maxRetries) {
//         await Future.delayed(retryDelay);
//         return finishOrder(
//           sessionId,
//           paymentMethodId,
//           cashierId,
//           customerId,
//           isTipped,
//           tipAmount,
//           cartLines,
//           deliveryUserId,
//           context,
//           retryCount: retryCount + 1,
//         );
//       } else {
//         return null;
//       }
//     } catch (e) {
//       log('finishOrder error >> $e');
//       if (retryCount < maxRetries) {
//         await Future.delayed(retryDelay);
//         return finishOrder(
//           sessionId,
//           paymentMethodId,
//           cashierId,
//           customerId,
//           isTipped,
//           tipAmount,
//           cartLines,
//           deliveryUserId,
//           context,
//           retryCount: retryCount + 1,
//         );
//       } else {
//         Navigation().closeDialog(context);
//         return null;
//       }
//     }
//   }

//   Future<CheckOut?> finishOrderForKioskOrder(
//     int sessionId,
//     int paymentMethodId,
//     int cashierId,
//     int customerId,
//     bool isTipped,
//     double tipAmount,
//     List<allkiosk.OrderLine> cartLines,
//     int deliveryUserId,
//     BuildContext context,
//   ) async {
//     String url = 'http://157.180.26.238:10000/finalize_order';

//     log('''
//  {
//         "session_id": $sessionId,
//         "payment_method_id": $paymentMethodId,
//         "cashier_id": $cashierId,
//         "customer_id": $customerId,
//         "is_tipped": $isTipped,
//         "tip_amount": $tipAmount,
//         "products": [
//         ],
//         "res_delivery_id": $deliveryUserId
//          "to_invoice": ${deliveryUserId == 0 ? true : false}
//       }

//         ''');

//     try {
//       final response = await Client.client.post(
//         url,
//         data: {
//           "session_id": sessionId,
//           "payment_method_id": paymentMethodId,
//           "cashier_id": cashierId,
//           "customer_id": customerId,
//           "is_tipped": isTipped,
//           "tip_amount": tipAmount,
//           "products": [
//             for (var item in cartLines)
//               {
//                 "product_id": item.productId,
//                 "qty": item.qty,
//                 "price_unit": item.priceUnit,
//                 "discount": item.discount,
//                 "tax_ids": item.taxIds == 0 ? [] : [item.taxIds],
//                 "price_subtotal": item.priceSubtotal,
//                 "price_subtotal_incl": item.priceSubtotalIncl,
//                 "full_product_name": item.fullProductName,
//                 "customer_note": item.customerNote,
//                 "kitchen_note": item.kitchenNote,
//                 "price_type": item.priceType,
//               },
//           ],
//           "res_delivery_id": deliveryUserId,
//           "to_invoice": deliveryUserId == 0 ? true : false,
//           "is_kiosk": true,
//           "customer_name": "",
//           "customer_phone": "",
//           "waiter_name": "",
//         },
//       );
//       if (response.statusCode == 200) {
//         print(response.data.toString());

//         CheckOut checkOut = CheckOut.fromJson(response.data);
//         return checkOut;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       Navigation().closeDialog(context);
//       //*

//       log('finishOrderForKioskOrder error >> $e');

//       // throw 'finishOrder error >> $e';
//       return null;
//     }
//   }

//   Future<StatusMsgModel?> processKioskOrder(int orderId) async {
//     String url = 'http://157.180.26.238:10000/process_kiosk_order/$orderId';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
//         return statusMsgModel;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'processKioskOrder error >> $e';
//     }
//   }

//   Future<DeliveryUsers?> getAllUsers() async {
//     String url = 'http://157.180.26.238:10000/get_all_res_delivery';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         DeliveryUsers allUsers = DeliveryUsers.fromJson(response.data);
//         return allUsers;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getAllUsers error >> $e';
//     }
//   }

//   Future<DeliveryUsers?> getDeliveryUserById(int userId) async {
//     String url = 'http://157.180.26.238:10000/get_res_delivery_by_id/$userId';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         DeliveryUsers allUsers = DeliveryUsers.fromJson(response.data);
//         return allUsers;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getDeliveryUserById error >> $e';
//     }
//   }

//   Future<DeliveryUsers?> getDeliveryUserByNumber(String phoneNumber) async {
//     String url = 'http://157.180.26.238:10000/get_res_delivery_by_phone/$phoneNumber';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         DeliveryUsers allUsers = DeliveryUsers.fromJson(response.data);
//         return allUsers;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getDeliveryUserByNumber error >> $e';
//     }
//   }

//   Future<AddDeliveryUser?> addDeliveryUser(String userName, String userPhone, String userAddress) async {
//     String url = 'http://157.180.26.238:10000/new_res_delivery';

//     try {
//       final response = await Client.client.post(url, data: {"name": userName, "phone": userPhone, "address": userAddress});

//       if (response.statusCode == 200) {
//         AddDeliveryUser addDeliveryUser = AddDeliveryUser.fromJson(response.data);
//         return addDeliveryUser;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'addDeliveryUser error >> $e';
//     }
//   }

//   Future<StatusMsgModel?> closeSession(int sessionId, double closingCash, String closingNotes) async {
//     String url = 'http://157.180.26.238:10000/close_pos_session';

//     try {
//       final response = await Client.client.post(
//         url,
//         data: {"session_id": sessionId, "closing_cash": closingCash, "notes": closingNotes},
//       );

//       if (response.statusCode == 200) {
//         StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
//         return statusMsgModel;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'closeSession error >> $e';
//     }
//   }

//   Future<AllSessionOrders?> getAllSessionOrders(int sessionId) async {
//     String url = 'http://157.180.26.238:10000/get_session_orders/$sessionId';
//     print(url);

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         AllSessionOrders allSessionOrders = AllSessionOrders.fromJson(response.data);
//         return allSessionOrders;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getAllSessionOrders error >> $e';
//     }
//   }

//   Future<RegisterDeliveryPayment?> generateAndRegisterDeliveryOrder(int orderId, int journalId) async {
//     String url = 'http://157.180.26.238:10000/generate_delivery_order_invoice/$orderId';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         GenerateDeliveryPayment generateDeliveryPayment = GenerateDeliveryPayment.fromJson(response.data);

//         if (generateDeliveryPayment.status == 1) {
//           //*
//           String urlPost = 'http://157.180.26.238:10000/register_delivery_order_payment';

//           final responsePost = await Client.client.post(
//             urlPost,
//             data: {"invoice_id": generateDeliveryPayment.invoiceId, "journal_id": journalId},
//           );

//           log(response.data.toString());

//           if (responsePost.statusCode == 200) {
//             log(responsePost.data.toString());
//             RegisterDeliveryPayment registerDeliveryPayment = RegisterDeliveryPayment.fromJson(responsePost.data);
//             return registerDeliveryPayment;
//           } else {
//             return null;
//           }
//           //*
//         } else {
//           return null;
//         }
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'generateAndRegisterDeliveryOrder error >> $e';
//     }
//   }

//   Future<ClosingSessionData?> getClosingSessionData(int sessionId) async {
//     String url = 'http://157.180.26.238:10000/get_session_closing_data/$sessionId';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         ClosingSessionData closingSessionData = ClosingSessionData.fromJson(response.data);
//         return closingSessionData;
//       } else {
//         return null;
//       }
//     } catch (e) {}
//     return null;
//   }

//   Future<DraftRefundOrder?> draftRefundOrderFirst(int orderId) async {
//     String url = 'http://157.180.26.238:10000/draft_refund_order/$orderId';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         DraftRefundOrder draftRefundOrder = DraftRefundOrder.fromJson(response.data);
//         log(response.data.toString());
//         return draftRefundOrder;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'draftRefundOrder error >> $e';
//     }
//   }

//   Future<RefundOrderPayment?> refundOrderPaymentSecond(int posId, int sessionId, int refundOrderId) async {
//     String url = 'http://157.180.26.238:10000/refund_order_payment';

//     try {
//       final response = await Client.client.post(
//         url,
//         data: {"pos_id": posId, "session_id": sessionId, "refund_order_id": refundOrderId},
//       );
//       if (response.statusCode == 200) {
//         RefundOrderPayment refundOrderPayment = RefundOrderPayment.fromJson(response.data);
//         log(response.data.toString());
//         return refundOrderPayment;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'refundOrderPaymentSecond error >> $e';
//     }
//   }

//   Future<ReverseRefundOrder?> reverseRefundOrderInvoiceThird(int posId, int sessionId, int refundOrderId) async {
//     String url = 'http://157.180.26.238:10000/reverse_refund_order_invoice';

//     try {
//       final response = await Client.client.post(
//         url,
//         data: {"pos_id": posId, "session_id": sessionId, "refund_order_id": refundOrderId},
//       );
//       if (response.statusCode == 200) {
//         ReverseRefundOrder reverseRefundOrder = ReverseRefundOrder.fromJson(response.data);
//         log(response.data.toString());
//         return reverseRefundOrder;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'ReverseRefundOrderInvoiceThird error >> $e';
//     }
//   }

//   Future<SearchByReceipt?> searchOrderByReceipt(String receiptNumber) async {
//     String url = 'http://157.180.26.238:10000/search_order_receipt/$receiptNumber';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         SearchByReceipt searchByReceipt = SearchByReceipt.fromJson(response.data);
//         return searchByReceipt;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'searchOrderByReceipt error >> $e';
//     }
//   }

//   Future<allkiosk.AllKioskOrders?> getAllKioskOrders(int sessionId) async {
//     String url = 'http://157.180.26.238:10000/get_session_all_kiosk_orders/$sessionId';

//     print(url);

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         allkiosk.AllKioskOrders allKioskOrders = allkiosk.AllKioskOrders.fromJson(response.data);
//         return allKioskOrders;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getAllKioskOrders error >> $e';
//     }
//   }

//   Future<DiscountModel?> getDiscountData() async {
//     String url = 'http://157.180.26.238:10000/get_pos_discount_product';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         DiscountModel discountModel = DiscountModel.fromJson(response.data);
//         return discountModel;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getDiscountData error >> $e';
//     }
//   }
//   //TODO
//   // Future<StatusMsgModel?> addClientUniqueID(String deviceID) async {
//   //   String url = 'http://157.180.26.238:10000/set_client_unique_id';

//   //   try {
//   //     final response = await Client.client.post(url, data: {"dummy": "string", "unique_id": deviceID});
//   //     if (response.statusCode == 200) {
//   //       StatusMsgModel statusMsgModel = StatusMsgModel.fromJson(response.data);
//   //       return statusMsgModel;
//   //     } else {
//   //       return null;
//   //     }
//   //   } catch (e) {
//   //     throw 'addClientUniqueID error >> $e';
//   //   }
//   // }

//   Future<int?> getCustomerID() async {
//     String url = 'http://157.180.26.238:10000/get_customer_account';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         return response.data['data'];
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getCustomerID error >> $e';
//     }
//   }

//   // Future<>
// }
