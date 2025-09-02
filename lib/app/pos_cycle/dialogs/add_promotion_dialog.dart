import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

class AddPromotionDialog extends StatefulWidget {
  const AddPromotionDialog({super.key});

  @override
  State<AddPromotionDialog> createState() => _AddPromotionDialogState();
}

class _AddPromotionDialogState extends State<AddPromotionDialog> {
  final formKey = GlobalKey<FormState>();

  bool isPromoCodeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final menuProviderWatch = context.watch<MenuProvider>();
    final menuProviderRead = context.read<MenuProvider>();

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      content: Directionality(
        textDirection: context.locale == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
        child: Form(
          key: formKey,
          child: SizedBox(
            width: AppDimentions().availableWidth * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPromoCodeEnabled = true;
                        });
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: goSmartBlue),
                        child: isPromoCodeEnabled
                            ? Center(
                                child: Image.asset(
                                'assets/images/check-mark.png',
                                height: 27.h,
                                width: 27.w,
                                color: white,
                              ))
                            : Container(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'promotion_code'.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPromoCodeEnabled = false;
                        });
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: goSmartBlue),
                        child: !isPromoCodeEnabled
                            ? Center(child: Image.asset('assets/images/check-mark.png', color: white, height: 27.h, width: 27.w))
                            : Container(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'third_party_promotion'.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                //* //*
                SizedBox(height: 20.h),
                //* //*
                TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                      labelText: 'enter_promotion_code'.tr(),
                      floatingLabelStyle: const TextStyle(
                        color: goSmartBlue,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide(color: goSmartBlue, width: 2.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide(color: goSmartBlue, width: 2.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                        borderSide: BorderSide(color: goSmartBlue, width: 2.w),
                      ),
                      //* //*
                      enabled: isPromoCodeEnabled,
                      //* //*
                      suffixIcon: Container(
                          height: 40.h,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(isPromoCodeEnabled ? Colors.green : Colors.grey),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                ),
                              ),
                              onPressed: isPromoCodeEnabled ? () {} : null,
                              child: Text('apply_code'.tr())))),
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Text('add_promo_code'.tr()),
                //     SizedBox(width: 10.w),
                //     Expanded(
                //       child: TextFormField(
                //         textAlign: TextAlign.start,
                //         style: TextStyle(fontSize: 16.sp),
                //         decoration: InputDecoration(
                //           hintText: 'add_promo_code'.tr(),
                //           contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10.r),
                //             borderSide: BorderSide(color: Colors.grey.shade300, width: 1.w),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
