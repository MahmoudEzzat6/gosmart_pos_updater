import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/add_customer_waiter_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/cancel_order_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/check_out.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/selected_payment_method_widget.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/dialogs/open_cheque_payment_success_dialog.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/add_discount_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/add_promotion_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/payment_successful_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/cart_item_widget.dart';
import 'package:pos_windows_ice_hub/main.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../../helpers/application_dimentions.dart';

class OpenChequeCheckoutDialog extends StatelessWidget {
  final bool isAdmin;
  final ScreenshotController screenshotControllerOpenCheque;

  const OpenChequeCheckoutDialog({super.key, required this.screenshotControllerOpenCheque, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    //*
    print('SCREENSHOT >> ${screenshotControllerOpenCheque.hashCode}');
    //*
    AppDimentions().appDimentionsInit(context);
    final openChequeProviderRead = context.read<OpenChequeProvider>();
    final openChequeProviderWatch = context.watch<OpenChequeProvider>();

    final posProviderRead = context.read<PosProvider>();

    final dialogWidth = AppDimentions().availableWidth * 0.75;

    Future<void> checkOut() async {
      log('''
                          SessionID: ${posProviderRead.currentSession.data![0].id}
                          PaymentMethodID: ${posProviderRead.selectedPaymentMethodId}
                          CashierID: ${posProviderRead.currentSession.data![0].cashierId}
                          CustomerID: 7
                          isTipped: false
                          tipAmount: 0
                          products: [
                            ${openChequeProviderRead.selectedCheque.cartItems.map((item) => '''
                              {
                                "product_id": ${item.productId}
                                "qty": ${item.quantity}
                                "price_unit": ${item.priceUnit}
                                "discount" : ${item.discount}
                                "tax_ids" : ${item.taxIds}
                                "price_subtotal": ${item.priceSubtotalWithoutTax}
                                "price_subtotal_incl": ${item.priceWithTax}
                                "full_product_name": ${item.productName}
                                "customer_note": ${item.customerNote}
                                "kitchen_note": ${item.kitchenNote}
                                "price_type": ${item.priceType}
                              }
                            ''').join(',')}
                          ]
                              ''');

      //*
      Navigation().showLoadingGifDialog(context);

      //   CheckOut checkOut = CheckOut();

      Map<String, dynamic> customerData = {
        'customerName': '',
        'customerPhone': '',
        'waiterName': openChequeProviderWatch.selectedCheque.tableName,
      };

      context.read<MenuProvider>().setCustomerData = customerData;

      await PosApis()
          .finishOrder(
              posProviderRead.currentSession.data![0].id!,
              posProviderRead.selectedPaymentMethodId,
              isAdmin ? posProviderRead.adminId : posProviderRead.currentSession.data![0].cashierId!,
              posProviderRead.customerId,
              false,
              0,
              openChequeProviderRead.selectedCheque.cartItems,
              posProviderRead.isDeliveryOrder ? posProviderRead.deliveryUsers.data![0].id! : 0,
              context)
          .then((checkoutResponse) async {
        if (checkoutResponse == null) {
          //*
          await checkOut();
          //*
        } else {
          context.read<PosProvider>().setLatestOrderRefrence = checkoutResponse.result!.receiptNumber!;
          context.read<PosProvider>().setLatestOrderNumber = checkoutResponse.result!.orderNumber!;

          Navigation().closeDialog(context);
          //*
          showDialog(
              context: context,
              builder: (context) => OpenChequePaymentSuccessDialog(
                    screenshotControllerOpenCheque: screenshotControllerOpenCheque,
                  ));
        }
      });
    }

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      content: SizedBox(
        width: dialogWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                width: dialogWidth * 0.55,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: AppDimentions().availableheightNoAppBar * 0.08,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'payment'.tr(),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 19.sp,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                onPressed: () {
                                  Navigation().closeDialog(context);
                                },
                                icon: const Icon(Icons.close, color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    const Divider(),
                    Container(
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color.fromRGBO(225, 225, 225, 1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(width: 10.w),
                              Text(
                                'subtotal'.tr(),
                                style: mediumText.copyWith(color: textGrey, fontSize: 19.sp),
                              ),
                              const Spacer(),
                              Text(
                                '${openChequeProviderWatch.selectedCheque.subtotal.toStringAsFixed(2)} ${'egp'.tr()}',
                                style: mediumText.copyWith(color: textGrey, fontSize: 19.sp),
                              ),
                              SizedBox(width: 10.w),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(width: 10.w),
                              Text(
                                'tax'.tr(),
                                style: mediumText.copyWith(color: textGrey, fontSize: 19.sp),
                              ),
                              const Spacer(),
                              Text(
                                '${openChequeProviderWatch.selectedCheque.taxes.toStringAsFixed(2)} ${'egp'.tr()}',
                                style: mediumText.copyWith(color: textGrey, fontSize: 19.sp),
                              ),
                              SizedBox(width: 10.w),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          // Container(
                          //   decoration: const BoxDecoration(
                          //     color: Color.fromRGBO(248, 241, 225, 1),
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     mainAxisSize: MainAxisSize.max,
                          //     children: [
                          //       SizedBox(width: 20.w),
                          //       Text(
                          //         'discount'.tr(),
                          //         style: mediumText.copyWith(color: goSmartBlue, fontSize: 19.sp),
                          //       ),
                          //       const Spacer(),
                          //       Text(
                          //         '-${openChequeProviderWatch.selectedCheque.d.toStringAsFixed(2)} ${'egp'.tr()}',
                          //         style: mediumText.copyWith(color: goSmartBlue, fontSize: 19.sp),
                          //       ),
                          //       SizedBox(width: 20.w),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(width: 10.w),
                              Text(
                                'total'.tr(),
                                style: boldText.copyWith(fontSize: 20.sp),
                              ),
                              const Spacer(),
                              Text(
                                '${(openChequeProviderWatch.selectedCheque.total).toStringAsFixed(2)} ${'egp'.tr()}',
                                style: boldText.copyWith(fontSize: 20.sp),
                              ),
                              SizedBox(width: 10.w),
                            ],
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                    //* //*
                    SizedBox(height: 10.h),
                    //* //*
                    //TODO REMOVE DISCOUNT
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Expanded(
                    //       flex: 5,
                    //       child: SizedBox(
                    //         height: 50.h,
                    //         child: ElevatedButton.icon(
                    //           style: ButtonStyle(
                    //             backgroundColor: WidgetStatePropertyAll(
                    //                 context.watch<PosProvider>().promotionApplied ? Colors.grey : goSmartBlue),
                    //             shape: WidgetStatePropertyAll(
                    //               RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(10.r),
                    //               ),
                    //             ),
                    //           ),
                    //           label: Text(
                    //             context.watch<MenuProvider>().discount != 0 ? 'remove_discount'.tr() : 'add_discount'.tr(),
                    //             style: mediumText.copyWith(
                    //               fontSize: 18.sp,
                    //               color: white,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //           icon: Image.asset(
                    //             'assets/images/discount.png',
                    //             height: 20.h,
                    //             width: 20.w,
                    //             color: white,
                    //           ),
                    //           onPressed: context.watch<PosProvider>().promotionApplied
                    //               ? null
                    //               : () {
                    //                   if (context.read<MenuProvider>().discount != 0) {
                    //                     context.read<MenuProvider>().setDiscount(0);

                    //                     context
                    //                         .read<MenuProvider>()
                    //                         .cartItems
                    //                         .removeWhere((element) => element.productName == 'Discount');

                    //                     context.read<PosProvider>().setDiscountApplied = false;
                    //                     context.read<PosProvider>().setPromotionApplied = false;
                    //                   } else {
                    //                     showDialog(context: context, builder: (context) => const AddDiscountDialog());
                    //                   }
                    //                 },
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(width: 20.w),
                    //     Expanded(
                    //       flex: 5,
                    //       child: SizedBox(
                    //         height: 50.h,
                    //         child: ElevatedButton.icon(
                    //           style: ButtonStyle(
                    //             backgroundColor: WidgetStatePropertyAll(
                    //                 context.watch<PosProvider>().discountApplied ? Colors.grey : goSmartBlue),
                    //             shape: WidgetStatePropertyAll(
                    //               RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(10.r),
                    //               ),
                    //             ),
                    //           ),
                    //           label: Text(
                    //             'add_promotion'.tr(),
                    //             style: mediumText.copyWith(
                    //               fontSize: 18.sp,
                    //               color: white,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //           icon: Image.asset(
                    //             'assets/images/promotion.png',
                    //             height: 20.h,
                    //             width: 20.w,
                    //             color: white,
                    //           ),
                    //           onPressed: context.watch<PosProvider>().discountApplied
                    //               ? null
                    //               : () {
                    //                   showDialog(context: context, builder: (context) => const AddPromotionDialog());
                    //                 },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //* //*
                    SizedBox(height: 10.h),
                    Text(
                      'payment_method'.tr(),
                      style: mediumText,
                    ),
                    SizedBox(height: 20.h),
                    const Expanded(child: SelectedPaymentMethodWidget()),
                    //    const Spacer(),
                    BlueButton(
                      label: 'confirm_payment'.tr(),
                      onPressed: () async {
                        if (await hasInternet(context)) {
                          await checkOut();
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => OkDialog(
                                  text: 'please_check_internet_connection'.tr(),
                                  onPressed: () {
                                    Navigation().closeDialog(context);
                                  }));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            Container(
              width: 1.w,
              color: const Color.fromRGBO(225, 225, 225, 1),
            ),
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            //* //* //* //*
            Container(
              width: dialogWidth * 0.44,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: AppDimentions().availableheightNoAppBar * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'order_details'.tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 19.sp,
                          ),
                        ),
                        //  const Spacer(),

                        // GestureDetector(
                        //   onTap: () {
                        //     showDialog(context: context, builder: (context) => const CancelOrderDialog());
                        //   },
                        //   child: Image.asset(
                        //     'assets/images/bin.png',
                        //     height: 25.h,
                        //     width: 25.w,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  const Divider(),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color.fromRGBO(225, 225, 225, 1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   mainAxisSize: MainAxisSize.max,
                          //   children: [
                          //     Text(
                          //       'order_number'.tr(),
                          //       style: mediumText,
                          //     ),
                          //     const Spacer(),
                          //     Text(
                          //       '1214552',
                          //       style: mediumText,
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'date'.tr(),
                                style: mediumText,
                              ),
                              const Spacer(),
                              Text(
                                intl.DateFormat('E d MMMM yyyy', 'ar').format(DateTime.now()),
                                style: mediumText,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'dine_in'.tr(),
                            style: mediumText,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            openChequeProviderWatch.selectedCheque.tableName,
                            style: mediumText,
                          ),

                          //*
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // height: AppDimentions().availableheightNoAppBar * 0.6,
                      padding: const EdgeInsets.all(10),
                      color: bgColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${'items'.tr()} (${openChequeProviderWatch.selectedCheque.cartItems.length})',
                            style: mediumText.copyWith(fontSize: 18.sp),
                          ),
                          Expanded(
                            child: Directionality(
                              textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                              child: ListView.builder(
                                itemCount: openChequeProviderWatch.selectedCheque.cartItems.length,
                                itemBuilder: (context, index) {
                                  return CartItemWidget(
                                    key: ValueKey(openChequeProviderWatch.selectedCheque.cartItems[index].productId),
                                    id: openChequeProviderWatch.selectedCheque.cartItems[index].productId,
                                    name: openChequeProviderWatch.selectedCheque.cartItems[index].productName,
                                    nameAr: openChequeProviderWatch.selectedCheque.cartItems[index].productName,
                                    size: openChequeProviderWatch.selectedCheque.cartItems[index].selectedSize,
                                    extras: openChequeProviderWatch.selectedCheque.cartItems[index].extras,
                                    quantity: openChequeProviderWatch.selectedCheque.cartItems[index].quantity.toInt(),
                                    totalPrice: openChequeProviderWatch.selectedCheque.cartItems[index].priceWithTax,
                                    isExtra: openChequeProviderWatch.selectedCheque.cartItems[index].isExtra,
                                    notes: openChequeProviderWatch.selectedCheque.cartItems[index].customerNote,
                                    qtyAvailable: openChequeProviderWatch.selectedCheque.cartItems[index].qtyAvailable,
                                    //* //*
                                    isInCheckout: true,
                                    description: '',
                                    descriptionAr: '',
                                    image: '',
                                    taxId: const [],
                                    //* //*
                                    extraPriceListEdit: const [],
                                    selectedExtrasEdit: const [],
                                    selectedSizeIndexEdit: 0,
                                    numOfProductsEdit: 0,
                                    customerNote: '',
                                    orderTimeStamp: '',
                                    //* //*
                                    isDiscount: openChequeProviderWatch.selectedCheque.cartItems[index].productName == 'Discount'
                                        ? true
                                        : false,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
