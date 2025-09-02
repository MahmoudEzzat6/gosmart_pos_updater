import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccessfulDialog extends StatelessWidget {
  final ScreenshotController screenshotController;

  const PaymentSuccessfulDialog(
      {super.key, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    final menuProviderWatch = context.watch<MenuProvider>();
    return AlertDialog(
      content: PopScope(
        canPop: false,
        child: SizedBox(
          width: AppDimentions().availableWidth * 0.3,
          height: AppDimentions().availableheightWithAppBar * 0.4,
          child: Directionality(
            textDirection: context.locale.languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/order_copleted.png',
                  height: 100.h,
                  width: 100.w,
                ),
                SizedBox(height: 10.h),
                Text(
                  'تم الطلب بنجاح',
                  style: mediumText.copyWith(fontSize: 25.sp),
                ),
                Text(
                  '${(menuProviderWatch.cartTotal - menuProviderWatch.discount).toStringAsFixed(2)} ${'egp'.tr()}',
                  style: mediumText.copyWith(
                      fontSize: 30.sp,
                      color: goSmartBlue,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: goSmartBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  // onLongPress: () {
                  //   context.read<MenuProvider>().resetAfterFinishOrder(context);
                  //   //*
                  //   Navigation().closeDialog(context);
                  //   Navigation().closeDialog(context);
                  // },
                  onPressed: () async {
                    final posProvider = context.read<PosProvider>();
                    final menuProvider = context.read<MenuProvider>();

                    if (posProvider.usePrinter) {
                      if (posProvider.printName.isEmpty) {
                        Navigation().closeDialog(context);
                        showDialog(
                          context: context,
                          builder: (context) => OkDialog(
                            text: 'من فضلك تأكد من اتصالك بالطابعة',
                            onPressed: () {
                              menuProvider.resetAfterFinishOrder(context);
                              Navigation().closeDialog(context);
                              Navigation().closeDialog(context);
                            },
                          ),
                        );
                        return;
                      }

                      int copies = 1;
                      if (posProvider.isDeliveryOrder) {
                        final prefs = await SharedPreferences.getInstance();
                        copies = prefs.getInt('receipt_number') ?? 1;
                      }

                      for (int i = 0; i < copies; i++) {
                        await posProvider.printReceipt(
                          screenshotController,
                          posProvider.isUSBPrinter,
                        );
                      }
                    }

                    menuProvider.resetAfterFinishOrder(context);
                    Navigation().closeDialog(context);
                    Navigation().closeDialog(context);
                  },
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'طباعة الفاتورة',
                      style: boldText.copyWith(color: white, fontSize: 20.sp),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/images/invoice.png',
                    height: 30.h,
                    width: 30.w,
                    //  color: white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
