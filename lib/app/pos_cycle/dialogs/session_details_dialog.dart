import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/views/all_session_orders_screen.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

import '../../../styles/text_style.dart';

class SessionDetailsDialog extends StatelessWidget {
  final int sessionId;
  final String posName;
  final String sessionName;
  final String cashierName;
  final double openingCash;
  final double closingCash;
  final String state;
  final String startAt;
  final String closeAt;
  final String openingNote;
  final String closingNote;
  final int orderCount;
  final double totalPaymentsAmount;

  const SessionDetailsDialog(
      {super.key,
      required this.sessionId,
      required this.posName,
      required this.sessionName,
      required this.cashierName,
      required this.openingCash,
      required this.closingCash,
      required this.state,
      required this.startAt,
      required this.closeAt,
      required this.openingNote,
      required this.orderCount,
      required this.totalPaymentsAmount,
      required this.closingNote});

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    return AlertDialog(
      backgroundColor: bgColor,
      content: Directionality(
        textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: SizedBox(
          width: AppDimentions().availableWidth * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${'session'.tr()}: ',
                    style: boldText,
                  ),
                  Text(
                    sessionName,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Card(
                elevation: 3,
                color: white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: AppDimentions().availableWidth * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: goSmartBlue),
                            ),
                            child: Text(
                              'sales_information'.tr(),
                              style: mediumText,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.center,
                            //width: 80.w,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: state.toLowerCase() == 'closed' ? Colors.red.shade100 : Colors.green.shade100,
                            ),
                            child: Text(
                              state,
                              style: mediumText.copyWith(color: state.toLowerCase() == 'closed' ? Colors.red : Colors.green),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/dollar_two.png',
                            height: 15.h,
                            width: 15.w,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            '${'balance'.tr()}: $totalPaymentsAmount ${'egp'.tr()}',
                            style: mediumText,
                          ),
                          SizedBox(width: 100.w),
                          Image.asset(
                            'assets/images/orders.png',
                            height: 15.h,
                            width: 15.w,
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            '${'orders'.tr()}: $orderCount',
                            style: mediumText,
                          ),
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ColumnDataItem(label: 'pos'.tr(), data: posName),
                          ),
                          Expanded(
                            flex: 2,
                            child: ColumnDataItem(label: 'cashier'.tr(), data: cashierName),
                          ),
                          Expanded(
                            flex: 2,
                            child: ColumnDataItem(
                                label: 'opening_date'.tr(),
                                data: startAt.isEmpty ? '' : ez.DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(startAt))),
                          ),
                          Expanded(
                            flex: 2,
                            child: ColumnDataItem(
                                label: 'closing_date'.tr(),
                                data: closeAt.isEmpty ? '' : ez.DateFormat('dd/MM/yyyy h:m a').format(DateTime.parse(closeAt))),
                          ),
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ColumnDataItem(label: 'opening_cash'.tr(), data: '$openingCash ${'egp'.tr()}'),
                          ),
                          Expanded(
                            flex: 2,
                            child: ColumnDataItem(label: 'closing_cash'.tr(), data: '$closingCash ${'egp'.tr()}'),
                          ),
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: 20.h),
                      ColumnDataItem(label: 'opening_note'.tr(), data: openingNote),
                      SizedBox(height: 10.h),
                      ColumnDataItem(label: 'closing_note'.tr(), data: closingNote),
                      SizedBox(height: 50.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 35.h,
                            width: 200.w,
                            child: BlueButton(
                                label: 'close'.tr(),
                                onPressed: () {
                                  Navigation().closeDialog(context);
                                }),
                          ),
                          SizedBox(
                            height: 35.h,
                            width: 200.w,
                            child: BlueButton(
                                label: 'get_all_orders'.tr(),
                                onPressed: () async {
                                  Navigation().showLoadingGifDialog(context);

                                  await context.read<PosProvider>().getAllSessionOrders(sessionId);

                                  Navigation().closeDialog(context);

                                  Navigation().goToScreen(
                                      context,
                                      (context) => AllSessionOrdersScreen(
                                            cashierName: context.read<PosProvider>().allSessionOrders.data!.isEmpty
                                                ? ''
                                                : context.read<PosProvider>().allSessionOrders.data![0].cashier!,
                                            sessionId: sessionId,
                                          ));
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColumnDataItem extends StatelessWidget {
  final String label;
  final String data;

  const ColumnDataItem({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: mediumText.copyWith(fontSize: 16.sp, color: goSmartBlue),
        ),
        Text(
          data,
          style: mediumText.copyWith(fontSize: 14.sp, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
