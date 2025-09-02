import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:provider/provider.dart';

class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProviderWatch = context.watch<MenuProvider>();
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/bin_bg.png',
            height: 75.h,
            width: 75.w,
          ),
          SizedBox(height: 10.h),
          Text(
            'cancel_order'.tr(),
            style: mediumText.copyWith(fontSize: 22.sp, color: Colors.red),
          ),
          Text(
            'do_you_want_to_cancel'.tr(),
            style: mediumText.copyWith(fontSize: 14.sp, color: textGrey),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 100.w,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    backgroundColor: const WidgetStatePropertyAll(
                      Color.fromRGBO(202, 202, 199, 1),
                    ),
                  ),
                  onPressed: () {
                    Navigation().closeDialog(context);
                  },
                  child: Text('back'.tr(), style: boldText),
                ),
              ),
              SizedBox(
                width: 100.w,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    backgroundColor: const WidgetStatePropertyAll(
                      Color.fromRGBO(251, 170, 171, 1),
                    ),
                  ),
                  onPressed: () {
                    context.read<MenuProvider>().resetAfterFinishOrder(context);
                    Navigation().closeDialog(context);
                    Navigation().closeDialog(context);
                  },
                  child: Text(
                    'cancel'.tr(),
                    style: boldText.copyWith(color: Colors.red),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
