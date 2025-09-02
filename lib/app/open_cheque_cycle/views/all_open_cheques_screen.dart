import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/checkout_dialog.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/dialogs/change_table_name_dialog.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/dialogs/open_cheque_checkout_dialog.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/services/open_cheque_categories_screen.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/widgets/add_table_widget.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/widgets/open_cheque_cart_item.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:screenshot/screenshot.dart';

class AllOpenChequesScreen extends StatefulWidget {
  final bool isAdmin;

  const AllOpenChequesScreen({super.key, required this.isAdmin});

  @override
  State<AllOpenChequesScreen> createState() => _AllOpenChequesScreenState();
}

class _AllOpenChequesScreenState extends State<AllOpenChequesScreen> {
  ScreenshotController screenshotControllerOpenCheque = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final posProviderWatch = context.watch<PosProvider>();
    final openChequeProviderWatch = context.watch<OpenChequeProvider>();
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 9,
                child: context.watch<OpenChequeProvider>().selectedTableId.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              flex: 4,
                              child: OpenChequeCartScreen(
                                isAdmin: widget.isAdmin,
                                screenshotControllerOpenCheque: screenshotControllerOpenCheque,
                              )),
                          const Expanded(flex: 6, child: OpenChequeCategoriesScreen()),
                        ],
                      )
                    : Container()),
            //*
            //*
            //* TABLES TAB
            const Expanded(flex: 1, child: AddTableWidget()),
          ],
        ),
        //* //* //*
        //* //* //* //*
        Positioned(
          left: -1000,
          child: Screenshot(
            controller: screenshotControllerOpenCheque,
            child: Directionality(
              textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                width: 360,
                padding: const EdgeInsets.all(3),
                color: white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      'ICE   CREAM   HUB',
                      textAlign: TextAlign.center,
                      style: boldText.copyWith(fontSize: 22.sp, fontFamily: GoogleFonts.monoton().fontFamily),
                    ),
                    // Image.asset(
                    //   'assets/images/ice_logo2.png',
                    //   height: 50.h,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            'order_number'.tr(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            //  decoration: BoxDecoration(border: Border.all(color: black)),
                            child: Text(
                              posProviderWatch.latestOrderNumber.toString(),
                              style: boldText.copyWith(fontSize: 40.sp),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //*
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'date'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      intl.DateFormat('E d MMMM yyyy', 'ar').format(DateTime.now()),
                                      style: mediumText.copyWith(fontSize: 14.sp),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'time'.tr(),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      intl.DateFormat('hh:mm a', 'ar').format(DateTime.now()),
                                      style: mediumText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${'cashier'.tr()}:   ',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Text(
                            posProviderWatch.loginData.name!,
                            style: mediumText,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'dine_in'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      openChequeProviderWatch.selectedCheque.tableName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(),
                    Container(
                      decoration: const BoxDecoration(
                          //      color: black,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              flex: 5,
                              child: Text(
                                'product_name'.tr(),
                                style: mediumText.copyWith(color: black, fontSize: 12.sp),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                'quantity'.tr(),
                                textAlign: TextAlign.center,
                                style: mediumText.copyWith(color: black, fontSize: 12.sp),
                                maxLines: 1,
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                'price'.tr(),
                                textAlign: TextAlign.center,
                                style: mediumText.copyWith(color: black, fontSize: 12.sp),
                              )),
                          // Expanded(
                          //     flex: 2,
                          //     child: Text(
                          //       'tax'.tr(),
                          //       textAlign: TextAlign.center,
                          //       style: mediumText.copyWith(color: white, fontSize: 12.sp),
                          //       maxLines: 1,
                          //     )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                'total'.tr(),
                                style: mediumText.copyWith(color: black, fontSize: 12.sp),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    ...List.generate(
                      openChequeProviderWatch.selectedCheque.cartItems.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 5,
                                child: Text(
                                  openChequeProviderWatch.selectedCheque.cartItems[index].productName,
                                  style: boldText.copyWith(fontSize: 22.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  openChequeProviderWatch.selectedCheque.cartItems[index].quantity.toStringAsFixed(0),
                                  textAlign: TextAlign.center,
                                  style: boldText,
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  openChequeProviderWatch.selectedCheque.cartItems[index].priceUnit.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  style: boldText,
                                )),
                            // Expanded(
                            //     flex: 2,
                            //     child: Text(
                            //       menuProviderWatch.cartItems[index].productName == 'Discount'
                            //           ? ''
                            //           : menuProviderWatch.cartItems[index].taxesName,
                            //       textAlign: TextAlign.center,
                            //     )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  (openChequeProviderWatch.selectedCheque.cartItems[index].priceUnit *
                                          openChequeProviderWatch.selectedCheque.cartItems[index].quantity)
                                      .toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: boldText,
                                )),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'subtotal'.tr(),
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${openChequeProviderWatch.selectedCheque.subtotal.toStringAsFixed(2)} ${'egp'.tr()}',
                          style: mediumText.copyWith(
                            color: black,
                            fontSize: 17.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'tax'.tr(),
                          style: TextStyle(
                            fontSize: 17.sp,
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${openChequeProviderWatch.selectedCheque.taxes.toStringAsFixed(2)} ${'egp'.tr()}',
                          style: mediumText.copyWith(
                            color: black,
                            fontSize: 17.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'total'.tr(),
                          style: TextStyle(
                            fontSize: 23.sp,
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${openChequeProviderWatch.selectedCheque.total.toStringAsFixed(2)} ${'egp'.tr()}',
                          style: mediumText.copyWith(
                            color: black,
                            fontSize: 23.sp,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'الاسعار تشمل ضريبة القيمة المضافة',
                      textAlign: TextAlign.center,
                      style: mediumText.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'order_reference'.tr(),
                      textAlign: TextAlign.center,
                      style: mediumText.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(border: Border.all(color: black)),
                        child: Text(
                          posProviderWatch.latestOrderRefrence.toString(),
                          textAlign: TextAlign.center,
                          style: boldText.copyWith(fontSize: 16.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Text(
                    //       'للشكاوى و الاقتراحات',
                    //       style: TextStyle(
                    //         fontSize: 18.sp,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //     const Spacer(),
                    //     Text(
                    //       '01001000111',
                    //       style: mediumText.copyWith(
                    //         fontSize: 18.sp,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20.h),
                    Container(
                      color: black,
                      child: Text(
                        'Powered By GO Smart',
                        textAlign: TextAlign.center,
                        style: mediumText.copyWith(
                          color: white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                    Text(
                      'www.gosmart.eg',
                      textAlign: TextAlign.center,
                      style: mediumText.copyWith(
                        color: black,
                        fontSize: 13.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class OpenChequeCartScreen extends StatefulWidget {
  final bool isAdmin;
  final ScreenshotController screenshotControllerOpenCheque;

  const OpenChequeCartScreen({super.key, required this.isAdmin, required this.screenshotControllerOpenCheque});

  @override
  State<OpenChequeCartScreen> createState() => _OpenChequeCartScreenState();
}

class _OpenChequeCartScreenState extends State<OpenChequeCartScreen> {
  @override
  Widget build(BuildContext context) {
    final openChequeProviderWatch = context.watch<OpenChequeProvider>();

    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: openChequeProviderWatch.openChequesList.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(openChequeProviderWatch.selectedCheque.tableName,
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            showDialog(context: context, builder: (_) => const ChangeTableNameDialog());
                          },
                          icon: const Icon(Icons.edit)),
                      const SizedBox(width: 8),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return YesNoDialog(
                                    dialogText: "هل أنت متأكد من حذف هذه الطاولة؟",
                                    onYesPressed: () {
                                      context.read<OpenChequeProvider>().deleteTable(openChequeProviderWatch.selectedTableId);
                                      Navigator.of(context).pop();
                                    },
                                    onNoPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: openChequeProviderWatch.selectedCheque.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = openChequeProviderWatch.selectedCheque.cartItems[index];
                      return OpenChequeCartItem(
                        key: ValueKey(cartItem.productId),
                        id: cartItem.productId,
                        name: cartItem.productName,
                        nameAr: cartItem.productName,
                        //  image: cartItem.image,
                        size: cartItem.selectedSize,
                        extras: cartItem.extras,
                        quantity: cartItem.quantity.toInt(),
                        totalPrice: cartItem.priceWithTax,
                        isExtra: cartItem.isExtra,
                        notes: cartItem.customerNote,
                        //*
                        description: cartItem.description,
                        descriptionAr: cartItem.descriptionAr,
                        image: cartItem.image,
                        taxId: cartItem.taxIds,
                        qtyAvailable: cartItem.qtyAvailable,
                        //*
                        isInCheckout: false,
                        //*
                        extraPriceListEdit: cartItem.extraPriceList,
                        selectedExtrasEdit: cartItem.selectedExtrasEdit,
                        selectedSizeIndexEdit: cartItem.selectedSizeIndexEdit,
                        numOfProductsEdit: cartItem.numOfProductsEdit,
                        customerNote: cartItem.customerNote,
                        orderTimeStamp: cartItem.orderTimeStamp,
                        //*
                        isDiscount: cartItem.productName == 'Discount' ? true : false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.r),
                            topRight: Radius.circular(15.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${'total'.tr()}:", style: boldText),
                            Text(
                              "${openChequeProviderWatch.selectedCheque.total.toStringAsFixed(2)} ${'egp'.tr()}",
                              style: GoogleFonts.roboto(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: goSmartBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 70.h,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: ElevatedButton(
                            onPressed: () {
                              if (context.read<OpenChequeProvider>().selectedCheque.cartItems.isNotEmpty) {
                                showDialog(
                                    context: context,
                                    builder: (context) => OpenChequeCheckoutDialog(
                                          screenshotControllerOpenCheque: widget.screenshotControllerOpenCheque,
                                          isAdmin: widget.isAdmin,
                                        ));
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
                            child: Text("payment".tr(), style: boldText.copyWith(color: Colors.white))),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
}
