import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/checkout_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/set_delivery_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class CartBottomSection extends StatelessWidget {
  final ScreenshotController screenshotController;
  final double totalAmount;
  final bool isAdmin;

  const CartBottomSection({super.key, required this.totalAmount, required this.screenshotController, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final menuProviderRead = context.read<MenuProvider>();
    final menuProviderWatch = context.watch<MenuProvider>();

    final posProviderRead = context.read<PosProvider>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.r),
          topRight: Radius.circular(15.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          // Total Price Section
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${'total'.tr()}:", style: boldText),
                Text(
                  "${totalAmount.toStringAsFixed(2)} ${'egp'.tr()}",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: goSmartBlue,
                  ),
                ),
              ],
            ),
          ),

          // Dine-In & Delivery Buttons
          SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: menuProviderWatch.selectedOrderType == 'Take Away' ? goSmartBlue : Colors.white,
                        //  foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () {
                        menuProviderRead.setSelectedOrderType = "Take Away";
                        posProviderRead.setIsDeliveryOrder = false;
                      },
                      child: FittedBox(
                          child: Text(
                        "take_away".tr(),
                        style: boldText.copyWith(
                          color: menuProviderWatch.selectedOrderType == 'Take Away' ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                      )),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: menuProviderWatch.selectedOrderType == 'Delivery' ? goSmartBlue : Colors.white,
                        //   foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () {
                        menuProviderRead.setSelectedOrderType = "Delivery";
                        posProviderRead.setIsDeliveryOrder = true;

                        showDialog(context: context, builder: (context) => const SetDeliveryDialog());
                      },
                      child: Text("delivery".tr(),
                          style: boldText.copyWith(
                            color: menuProviderWatch.selectedOrderType == 'Delivery' ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: menuProviderWatch.selectedOrderType == 'Dine In' ? goSmartBlue : Colors.white,
                        //   foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      onPressed: () {
                        menuProviderRead.setSelectedOrderType = "Dine In";
                        posProviderRead.setIsDeliveryOrder = false;
                      },
                      child: Text("dine_in".tr(),
                          style: boldText.copyWith(
                            color: menuProviderWatch.selectedOrderType == 'Dine In' ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          SizedBox(height: 10.h),

          // Payment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goSmartBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              onPressed: () {
                // Handle payment action
                if (menuProviderRead.cartItems.isNotEmpty) {
                  print(posProviderRead.deliveryUsers.data!);
                  if (posProviderRead.isDeliveryOrder && posProviderRead.deliveryUsers.data!.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) => OkDialog(
                              text: 'من فضلك اختار عميل للتوصيل',
                              onPressed: () {
                                Navigation().closeDialog(context);
                              },
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => CheckoutDialog(
                              screenshotController: screenshotController,
                              isAdmin: isAdmin,
                            )).then((value) {
                      //* REMOVE DISCOUNT
                      menuProviderRead.setDiscount(0);

                      context.read<MenuProvider>().cartItems.removeWhere((element) => element.productName == 'Discount');
                    });
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => OkDialog(
                            text: 'من فضلك اختار منتج واحد على الاقل',
                            onPressed: () {
                              Navigation().closeDialog(context);
                            },
                          ));
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text("payment".tr(), style: boldText.copyWith(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
