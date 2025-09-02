import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart' as so;
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class OrderDetailsDialog extends StatelessWidget {
//  final so.Datum posProviderWatch.allSessionOrders.data![index];
  final int index;
  final int sessionId;

  OrderDetailsDialog({
    super.key,
    required this.index,
    required this.sessionId,
    // required this.posProviderWatch.allSessionOrders.data![index]
  });

  final ScreenshotController screenshotControllerOrderDetails = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final posProviderWatch = context.watch<PosProvider>();

    return AlertDialog(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: AppDimentions().availableWidth * 0.8,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigation().closeDialog(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.black)),
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 5,
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
                                        style: mediumText.copyWith(fontSize: 17.sp),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        posProviderWatch.allSessionOrders.data![index].orderNumber!,
                                        style: mediumText.copyWith(fontSize: 17.sp),
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
                                        'order_reference'.tr(),
                                        style: mediumText.copyWith(fontSize: 17.sp),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        posProviderWatch.allSessionOrders.data![index].posReference!,
                                        style: mediumText.copyWith(fontSize: 17.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                if (posProviderWatch.allSessionOrders.data![index].invoiceDetails!.isNotEmpty)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'معرف الفاتوره',
                                          style: mediumText.copyWith(fontSize: 17.sp),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          posProviderWatch.allSessionOrders.data![index].invoiceDetails![0].reference!,
                                          style: mediumText.copyWith(fontSize: 17.sp),
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
                                        style: mediumText.copyWith(fontSize: 17.sp),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        '${posProviderWatch.allSessionOrders.data![index].posName}',
                                        style: mediumText.copyWith(fontSize: 17.sp),
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
                                        style: mediumText.copyWith(fontSize: 17.sp),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        '${posProviderWatch.allSessionOrders.data![index].sessionName}',
                                        style: mediumText.copyWith(fontSize: 17.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //*
                          Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (posProviderWatch.allSessionOrders.data![index].customerName!.isNotEmpty)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'اسم العميل',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            '${posProviderWatch.allSessionOrders.data![index].customerName}',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (posProviderWatch.allSessionOrders.data![index].customerPhone!.isNotEmpty)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'رقم الهاتف',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            '${posProviderWatch.allSessionOrders.data![index].customerPhone}',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (posProviderWatch.allSessionOrders.data![index].waiterName!.isNotEmpty)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'اسم النادل',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            '${posProviderWatch.allSessionOrders.data![index].waiterName}',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (posProviderWatch.allSessionOrders.data![index].customerAddress!.isNotEmpty)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'العنوان',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            '${posProviderWatch.allSessionOrders.data![index].customerAddress}',
                                            style: mediumText.copyWith(fontSize: 17.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ))
                        ],
                      ),
                      if ((posProviderWatch.allSessionOrders.data![index].paymentData![0].type == 'delivery' &&
                              posProviderWatch.allSessionOrders.data![index].invoiceDetails!.isEmpty) ||
                          (posProviderWatch.allSessionOrders.data![index].paymentData![0].type == 'delivery' &&
                              posProviderWatch.allSessionOrders.data![index].invoiceDetails!.isNotEmpty &&
                              posProviderWatch.allSessionOrders.data![index].invoiceDetails![0].amountDue != 0))
                        Positioned(
                          left: 0,
                          top: 0.h,
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
                                                posProviderWatch.allSessionOrders.data![index].id!,
                                                posProviderWatch.allSessionOrders.data![index].paymentData![0].cashJournalId!,
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
                        itemCount: posProviderWatch.allSessionOrders.data![index].orderLines!.length,
                        itemBuilder: (context, secIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: Text(
                                        posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].fullProductName!)),
                                Expanded(
                                    flex: 1,
                                    child: Text(posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].qty!
                                        .toStringAsFixed(0))),
                                Expanded(
                                    flex: 1,
                                    child: Text(posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].priceUnit!
                                        .toStringAsFixed(2))),
                                Expanded(
                                    flex: 1,
                                    child: Text(posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].taxes!)),
                                Expanded(
                                    flex: 1,
                                    child: Text(posProviderWatch
                                        .allSessionOrders.data![index].orderLines![secIndex].priceSubtotalIncl!
                                        .toStringAsFixed(2))),
                              ],
                            ),
                          );
                        },
                        shrinkWrap: true),
                  ),
                  const Divider(),

                  //* ALL GOOD SHOW ALL DATA
                  ((posProviderWatch.allSessionOrders.data![index].paymentData![0].type != 'delivery') ||
                          ((posProviderWatch.allSessionOrders.data![index].paymentData![0].type == 'delivery') &&
                              posProviderWatch.allSessionOrders.data![index].invoiceDetails!.isNotEmpty &&
                              (posProviderWatch.allSessionOrders.data![index].invoiceDetails![0].amountDue == 0)))
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
                                      '${posProviderWatch.allSessionOrders.data![index].invoiceDetails![0].untaxedAmount!.toStringAsFixed(2)} ',
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
                                      '${posProviderWatch.allSessionOrders.data![index].invoiceDetails![0].taxes!.toStringAsFixed(2)} ',
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
                                      '${posProviderWatch.allSessionOrders.data![index].invoiceDetails![0].total!.toStringAsFixed(2)} ',
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
                                  '${posProviderWatch.allSessionOrders.data![index].amountTotal!.toStringAsFixed(2)} ',
                                  style: boldText.copyWith(fontSize: 25.sp),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'egp'.tr(),
                                  style: boldText.copyWith(fontSize: 20.sp),
                                )),
                          ],
                        ),
                  //* //*
                  SizedBox(height: 20.h),
                  //* //*
                  Center(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: goSmartBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () async {
                        print(context.read<PosProvider>().vendorId);
                        print(context.read<PosProvider>().productId);

                        int vendorId = context.read<PosProvider>().vendorId;
                        int productId = context.read<PosProvider>().productId;

                        String printName = context.read<PosProvider>().printName;

                        if (printName == '') {
                          showDialog(
                              context: context,
                              builder: (context) => OkDialog(
                                    text: 'من فضلك تأكد من اتصالك بالطابعة',
                                    onPressed: () {
                                      //*

                                      Navigation().closeDialog(context);
                                    },
                                  ));
                        } else {
                          await context
                              .read<PosProvider>()
                              .printReceipt(screenshotControllerOrderDetails, context.read<PosProvider>().isUSBPrinter);

                          //*
                        }
                      },
                      label: Text(
                        'طباعة الفاتورة',
                        style: boldText.copyWith(color: white, fontSize: 25.sp),
                      ),
                      icon: Image.asset(
                        'assets/images/invoice.png',
                        height: 30.h,
                        width: 30.w,
                        //  color: white,
                      ),
                    ),
                  ),
                ],
              ),
              //* //*
              //* //*
              Positioned(
                left: -1000,
                child: Screenshot(
                  controller: screenshotControllerOrderDetails,
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
                                    posProviderWatch.allSessionOrders.data![index].orderNumber.toString(),
                                    style: boldText.copyWith(fontSize: 40.sp, color: black),
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
                                            intl.DateFormat('E d MMMM yyyy', 'ar')
                                                .format(posProviderWatch.allSessionOrders.data![index].dateOrder!),
                                            style: mediumText.copyWith(fontSize: 14.sp),
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
                                            intl.DateFormat('hh:mm a', 'ar')
                                                .format(posProviderWatch.allSessionOrders.data![index].dateOrder!),
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
                          // Text(
                          //   menuProviderWatch.selectedOrderType == 'Take Away'
                          //       ? 'take_away'.tr()
                          //       : menuProviderWatch.selectedOrderType == 'Dine In'
                          //           ? 'dine_in'.tr()
                          //           : 'delivery'.tr(),
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontSize: 16.sp,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          //* IF DELIVERY USER
                          if (posProviderWatch.allSessionOrders.data![index].paymentData![0].type!.toLowerCase() ==
                              'delivery') ...[
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: black),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'اسم العميل   : ${posProviderWatch.allSessionOrders.data![index].customerName}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    'التليفون        : ${posProviderWatch.allSessionOrders.data![index].customerPhone}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    'العنوان          : ${posProviderWatch.allSessionOrders.data![index].customerAddress}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Divider(),
                          Container(
                            decoration: const BoxDecoration(),
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
                            posProviderWatch.allSessionOrders.data![index].orderLines!.length,
                            (secIndex) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Text(
                                        posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].fullProductName!,
                                        style: boldText,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].qty!
                                            .toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].priceUnit!
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                      )),
                                  // Expanded(
                                  //     flex: 2,
                                  //     child: Text(
                                  //       posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].fullProductName ==
                                  //               'Discount'
                                  //           ? ''
                                  //           : posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].taxes!,
                                  //       textAlign: TextAlign.center,
                                  //     )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        posProviderWatch.allSessionOrders.data![index].orderLines![secIndex].priceSubtotalIncl!
                                            .toStringAsFixed(2),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
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
                                '${((posProviderWatch.allSessionOrders.data![index].amountTotal!) - (posProviderWatch.allSessionOrders.data![index].amountTax!)).toStringAsFixed(2)} ${'egp'.tr()}',
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
                                '${posProviderWatch.allSessionOrders.data![index].amountTax!.toStringAsFixed(2)} ${'egp'.tr()}',
                                style: mediumText.copyWith(
                                  color: black,
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            child: Row(
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
                                  '${posProviderWatch.allSessionOrders.data![index].amountTotal!.toStringAsFixed(2)} ${'egp'.tr()}',
                                  style: mediumText.copyWith(
                                    color: black,
                                    fontSize: 23.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
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
                                posProviderWatch.allSessionOrders.data![index].posReference!,
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
          ),
        ),
      ),
    );
  }
}
