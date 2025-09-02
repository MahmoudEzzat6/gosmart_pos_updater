import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/refund_order_details_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/search_by_receipt.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

class RefundRequestDialog extends StatefulWidget {
  const RefundRequestDialog({super.key});

  @override
  State<RefundRequestDialog> createState() => _RefundRequestDialogState();
}

class _RefundRequestDialogState extends State<RefundRequestDialog> {
  final orderNumberController = TextEditingController();
  final orderNumberNode = FocusNode();

  SearchByReceipt searchByReceipt = SearchByReceipt(data: []);
  bool orderNotFound = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Directionality(
          textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: SizedBox(
            width: AppDimentions().availableWidth * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'refund_request'.tr(),
                  textAlign: TextAlign.center,
                  style: boldText,
                ),
                const SizedBox(height: 20),
                Text('refund_request_message'.tr()),
                const SizedBox(height: 20),
                TextField(
                  focusNode: orderNumberNode,
                  controller: orderNumberController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'order_number'.tr(),
                    isDense: true,
                    border: loginRegisterTextBorder,
                    errorBorder: loginRegisterTextBorder,
                    enabledBorder: loginRegisterTextBorder,
                    focusedBorder: loginRegisterTextBorder,
                  ),
                ),
                if (orderNotFound)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'order_not_found'.tr(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (orderNotFound == false && searchByReceipt.data!.isNotEmpty) ...[
                  SizedBox(height: 20.h),
                  ...List.generate(
                      searchByReceipt.data!.length,
                      (index) => GestureDetector(
                            onTap: () {
                              log('orderID: ${searchByReceipt.data![index].id}');
                              log('posID: ${searchByReceipt.data![index].posId}');
                              log('sessionID: ${searchByReceipt.data![index].sessionId}');

                              context.read<PosProvider>().setRefundOrderDetails = searchByReceipt.data![index];

                              showDialog(
                                  context: context,
                                  builder: (context) => RefundOrderDetailsDialog(
                                        orderId: searchByReceipt.data![index].id!,
                                        posId: searchByReceipt.data![index].posId!,
                                        sessionId: searchByReceipt.data![index].sessionId!,
                                        currentPosActiveSessionState: searchByReceipt.data![index].currentPosActiveSessionState!,
                                        currentPosActiveSessionId: searchByReceipt.data![index].currentPosActiveSessionId!,
                                        adminId: context.read<PosProvider>().loginData.userId!,
                                      ));
                            },
                            child: Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          searchByReceipt.data![index].posReference!,
                                          textAlign: TextAlign.center,
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          ez.DateFormat('dd-MM-yyyy').format(searchByReceipt.data![index].dateOrder!),
                                          textAlign: TextAlign.center,
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${searchByReceipt.data![index].amountTotal!.toStringAsFixed(2)} ${'egp'.tr()}',
                                          textAlign: TextAlign.center,
                                          style: boldText,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )),
                ],
                const SizedBox(height: 40),
                BlueButton(
                    label: 'search'.tr(),
                    onPressed: () async {
                      orderNumberNode.unfocus();

                      if (orderNumberController.text.isNotEmpty) {
                        //*
                        Navigation().showLoadingGifDialog(context);
                        //*
                        await PosApis().searchOrderByReceipt(orderNumberController.text).then((orders) {
                          Navigation().closeDialog(context);
                          //*
                          if (orders!.status == 1) {
                            //* THERE IS ORDERS
                            searchByReceipt = orders;
                            orderNotFound = false;

                            setState(() {});
                          } else {
                            orderNotFound = true;

                            setState(() {});
                          }
                        });
                        //*
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
