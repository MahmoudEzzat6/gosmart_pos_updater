import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart' as so;
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:provider/provider.dart';

class RefundOrderDetailsDialog extends StatelessWidget {
  final int sessionId;
  final int posId;
  final int orderId;
  final bool currentPosActiveSessionState;
  final int currentPosActiveSessionId;
  final int adminId;

  const RefundOrderDetailsDialog({
    super.key,
    required this.sessionId,
    required this.posId,
    required this.orderId,
    required this.adminId,
    required this.currentPosActiveSessionState,
    required this.currentPosActiveSessionId,
    // required this.posProviderWatch.refundOrderDetails
  });

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final posProviderWatch = context.watch<PosProvider>();

    return AlertDialog(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: AppDimentions().availableWidth * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'order_number'.tr(),
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              posProviderWatch.refundOrderDetails.orderNumber!,
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'معرف الفاتوره',
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              posProviderWatch.refundOrderDetails.posReference!,
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                        ],
                      ),
                      if (posProviderWatch.refundOrderDetails.invoiceDetails!.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'order_reference'.tr(),
                                style: mediumText.copyWith(fontSize: 20.sp),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Text(
                                posProviderWatch.refundOrderDetails.invoiceDetails![0].reference!,
                                style: mediumText.copyWith(fontSize: 20.sp),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'pos'.tr(),
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              '${posProviderWatch.refundOrderDetails.posName}',
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'session'.tr(),
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Text(
                              '${posProviderWatch.refundOrderDetails.sessionName}',
                              style: mediumText.copyWith(fontSize: 20.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if ((posProviderWatch.refundOrderDetails.paymentData![0].type == 'delivery' &&
                          posProviderWatch.refundOrderDetails.invoiceDetails!.isEmpty) ||
                      (posProviderWatch.refundOrderDetails.paymentData![0].type == 'delivery' &&
                          posProviderWatch.refundOrderDetails.invoiceDetails!.isNotEmpty &&
                          posProviderWatch.refundOrderDetails.invoiceDetails![0].amountDue != 0))
                    Positioned(
                      left: 0,
                      top: 20.h,
                      child: BlueButton(
                          label: 'توريد الفاتوره',
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) => YesNoDialog(
                                      dialogText: 'هل انت متأكد من توريد الفاتوره',
                                      onYesPressed: () async {
                                        Navigation().showLoadingGifDialog(context);
                                        //*
                                        await context.read<PosProvider>().generateAndRegisterDeliveryOrder(
                                            posProviderWatch.refundOrderDetails.id!,
                                            posProviderWatch.refundOrderDetails.paymentData![0].cashJournalId!,
                                            sessionId);

                                        Navigation().closeDialog(context);
                                        Navigation().closeDialog(context);
                                      },
                                      onNoPressed: () {
                                        Navigation().closeDialog(context);
                                      },
                                    ));
                            //*
                          }),
                    ),
                  Positioned(
                    left: 150.w,
                    top: 20.h,
                    child: CancelButton(
                        label: 'refund_item'.tr(),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => YesNoDialog(
                                    dialogText: 'هل انت متأكد من استرجاع الفاتوره',
                                    onYesPressed: () async {
                                      Navigation().showLoadingGifDialog(context);
                                      //*

                                      await context.read<PosProvider>().refundOrder(adminId, orderId, posId,
                                          currentPosActiveSessionState, currentPosActiveSessionId, context);

                                      // Navigation().closeDialog(context);
                                    },
                                    onNoPressed: () {
                                      Navigation().closeDialog(context);
                                    },
                                  ));
                          //*
                        }),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(flex: 6, child: Text('product_name'.tr())),
                  Expanded(flex: 1, child: Text('quantity'.tr())),
                  Expanded(flex: 1, child: Text('price'.tr())),
                  Expanded(flex: 1, child: Text('tax'.tr())),
                  Expanded(flex: 1, child: Text('total'.tr())),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                    itemCount: posProviderWatch.refundOrderDetails.orderLines!.length,
                    itemBuilder: (context, secIndex) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 6, child: Text(posProviderWatch.refundOrderDetails.orderLines![secIndex].fullProductName!)),
                            Expanded(
                                flex: 1,
                                child: Text(posProviderWatch.refundOrderDetails.orderLines![secIndex].qty!.toStringAsFixed(0))),
                            Expanded(
                                flex: 1,
                                child: Text(
                                    posProviderWatch.refundOrderDetails.orderLines![secIndex].priceUnit!.toStringAsFixed(2))),
                            Expanded(flex: 1, child: Text(posProviderWatch.refundOrderDetails.orderLines![secIndex].taxes!)),
                            Expanded(
                                flex: 1,
                                child: Text(posProviderWatch.refundOrderDetails.orderLines![secIndex].priceSubtotalIncl!
                                    .toStringAsFixed(2))),
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true),
              ),
              const Divider(),

              //* ALL GOOD SHOW ALL DATA
              ((posProviderWatch.refundOrderDetails.paymentData![0].type != 'delivery') ||
                      ((posProviderWatch.refundOrderDetails.paymentData![0].type == 'delivery') &&
                          posProviderWatch.refundOrderDetails.invoiceDetails!.isNotEmpty &&
                          (posProviderWatch.refundOrderDetails.invoiceDetails![0].amountDue == 0)))
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 8,
                                child: Text(
                                  'total_no_tax'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '${posProviderWatch.refundOrderDetails.invoiceDetails![0].untaxedAmount!.toStringAsFixed(2)} ',
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'egp'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 8,
                                child: Text(
                                  'tax'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '${posProviderWatch.refundOrderDetails.invoiceDetails![0].taxes!.toStringAsFixed(2)} ',
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'egp'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 8,
                                child: Text(
                                  'total'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '${posProviderWatch.refundOrderDetails.invoiceDetails![0].total!.toStringAsFixed(2)} ',
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'egp'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            flex: 8,
                            child: Text(
                              'total'.tr(),
                              style: boldText.copyWith(fontSize: 25.sp),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '${posProviderWatch.refundOrderDetails.amountTotal!.toStringAsFixed(2)} ',
                              style: boldText.copyWith(fontSize: 25.sp),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              'egp'.tr(),
                              style: boldText.copyWith(fontSize: 20.sp),
                            )),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
