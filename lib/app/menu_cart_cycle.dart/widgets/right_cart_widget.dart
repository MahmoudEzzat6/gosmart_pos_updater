import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/cart_bottom_widget.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/cart_item_widget.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../helpers/application_dimentions.dart';

class RightCartWidget extends StatelessWidget {
  final ScreenshotController? screenshotController;
  final bool isCustomer;
  final bool isAdmin;

  const RightCartWidget({super.key, this.screenshotController, required this.isCustomer, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    AppDimentions().appDimentionsInit(context);
    final menuProviderWatch = context.watch<MenuProvider>();

    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        color: white,
        padding: const EdgeInsets.only(top: 20, left: 10),
        child: Column(
          children: [
            if (menuProviderWatch.cartItems.isEmpty) ...[
              SizedBox(height: 100.h),
              Image.asset(
                'assets/images/EmptyState.png',
                height: 270.h,
                width: 330.w,
              ),
              Text(
                'cart_empty'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'start_make_order'.tr(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp,
                  color: const Color(0xff7A8B96),
                ),
              ),
              const Spacer(),
            ],
            if (menuProviderWatch.cartItems.isNotEmpty) ...[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Container(
                      //   height: AppDimentions().availableheightNoAppBar * 0.08,
                      //   padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         'الطلب رقم: 1214552',
                      //         style: GoogleFonts.poppins(
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 18.sp,
                      //         ),
                      //       ),
                      //       const Spacer(),
                      //       Text(
                      //         ez.DateFormat('E d MMMM yyyy', 'ar').format(DateTime.now()),
                      //         style: GoogleFonts.poppins(
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 18.sp,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(height: 5.h),
                      if (context.watch<PosProvider>().isDeliveryOrder &&
                          context.watch<PosProvider>().deliveryUsers.data!.isNotEmpty) ...[
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'اسم العميل   : ${context.watch<PosProvider>().deliveryUsers.data![0].name}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Text(
                                'التليفون        : ${context.watch<PosProvider>().deliveryUsers.data![0].phone}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                              Text(
                                'العنوان         : ${context.watch<PosProvider>().deliveryUsers.data![0].address}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(indent: 10, endIndent: 20),
                      ],

                      Container(
                        padding: const EdgeInsets.all(10),
                        color: bgColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${'items'.tr()} (${menuProviderWatch.cartItems.length})',
                              style: mediumText.copyWith(fontSize: 18.sp),
                            ),
                            Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              child: ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: menuProviderWatch.cartItems.length,
                                itemBuilder: (context, index) {
                                  return CartItemWidget(
                                    key: ValueKey(menuProviderWatch.cartItems[index].productId),
                                    id: menuProviderWatch.cartItems[index].productId,
                                    name: menuProviderWatch.cartItems[index].productName,
                                    nameAr: menuProviderWatch.cartItems[index].productName,
                                    //  image: menuProviderWatch.cartItems[index].image,
                                    size: menuProviderWatch.cartItems[index].selectedSize,
                                    extras: menuProviderWatch.cartItems[index].extras,
                                    quantity: menuProviderWatch.cartItems[index].quantity.toInt(),
                                    totalPrice: menuProviderWatch.cartItems[index].priceWithTax,
                                    isExtra: menuProviderWatch.cartItems[index].isExtra,
                                    notes: menuProviderWatch.cartItems[index].customerNote,
                                    //*
                                    description: menuProviderWatch.cartItems[index].description,
                                    descriptionAr: menuProviderWatch.cartItems[index].descriptionAr,
                                    image: menuProviderWatch.cartItems[index].image,
                                    taxId: menuProviderWatch.cartItems[index].taxIds,
                                    qtyAvailable: menuProviderWatch.cartItems[index].qtyAvailable,
                                    //*
                                    isInCheckout: false,
                                    //*
                                    extraPriceListEdit: menuProviderWatch.cartItems[index].extraPriceList,
                                    selectedExtrasEdit: menuProviderWatch.cartItems[index].selectedExtrasEdit,
                                    selectedSizeIndexEdit: menuProviderWatch.cartItems[index].selectedSizeIndexEdit,
                                    numOfProductsEdit: menuProviderWatch.cartItems[index].numOfProductsEdit,
                                    customerNote: menuProviderWatch.cartItems[index].customerNote,
                                    orderTimeStamp: menuProviderWatch.cartItems[index].orderTimeStamp,
                                    //*
                                    isDiscount: menuProviderWatch.cartItems[index].productName == 'Discount' ? true : false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            /// **Fixed Bottom Cart Section**
            ///
            if (isCustomer == false)
              CartBottomSection(
                totalAmount: menuProviderWatch.cartTotal + menuProviderWatch.taxTotal,
                screenshotController: screenshotController!,
                isAdmin: isAdmin,
              ),
          ],
        ),
      ),
    );
  }
}
