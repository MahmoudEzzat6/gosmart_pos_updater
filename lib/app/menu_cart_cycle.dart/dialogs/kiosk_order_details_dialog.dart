import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_kiosk_orders.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart' as so;
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:provider/provider.dart';

class KioskOrderDetailsDialog extends StatelessWidget {
  final Datum kioskOrder;

  const KioskOrderDetailsDialog({
    super.key,
    required this.kioskOrder,

    // required this.posProviderWatch.allSessionOrders.data![index]
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
                      kioskOrder.id!.toString(),
                      style: mediumText.copyWith(fontSize: 20.sp),
                    ),
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
                    itemCount: kioskOrder.orderLines!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(flex: 6, child: Text(kioskOrder.orderLines![index].fullProductName!)),
                            Expanded(flex: 1, child: Text(kioskOrder.orderLines![index].qty!.toStringAsFixed(0))),
                            Expanded(flex: 1, child: Text(kioskOrder.orderLines![index].priceUnit!.toStringAsFixed(2))),
                            Expanded(flex: 1, child: Text(kioskOrder.orderLines![index].taxIds.toString())),
                            Expanded(flex: 1, child: Text(kioskOrder.orderLines![index].priceSubtotalIncl!.toStringAsFixed(2))),
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true),
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
                        style: boldText.copyWith(fontSize: 25.sp),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        kioskOrder.cartTotal!.toStringAsFixed(2),
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
