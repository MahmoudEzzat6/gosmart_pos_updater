import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/all_kiosk_orders_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/order_details_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/session_details_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AllSessionOrdersScreen extends StatefulWidget {
  final String cashierName;
  final int sessionId;

  const AllSessionOrdersScreen({
    super.key,
    required this.cashierName,
    required this.sessionId,
  });

  @override
  State<AllSessionOrdersScreen> createState() => _AllSessionOrdersScreenState();
}

class _AllSessionOrdersScreenState extends State<AllSessionOrdersScreen> {
  final screenshotControllerKiosk = ScreenshotController();
  final ScrollController _scrollController = ScrollController(); //*mariam
  final searchController = TextEditingController();
  final searchNode = FocusNode();

  String filterChoice = 'price'.tr();
  List<String> filters = [
    'price'.tr(),
    'date'.tr(),
  ];

  void setFilterChoice(String value) {
    setState(() {
      filterChoice = value;
    });
  }

  bool sortUp = true;

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final posProviderRead = context.read<PosProvider>();
    final posProviderWatch = context.watch<PosProvider>();

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SizedBox(
          height: AppDimentions().availableheightWithAppBar,
          width: AppDimentions().availableWidth,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: AppDimentions().availableheightNoAppBar * 0.09,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(width: 20.w),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back, size: 25.sp, color: goSmartBlue)),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                // posProviderRead.currentSession.data![0].cashierName!,
                                widget.cashierName,
                                style: mediumText.copyWith(
                                  color: Colors.grey[400],
                                  fontSize: 17.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'cashier'.tr(),
                                style: mediumText.copyWith(
                                  color: Colors.grey[350],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: const EdgeInsets.only(left: 70),
                            height: 40.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            child: TextField(
                              controller: searchController,
                              focusNode: searchNode,
                              onChanged: posProviderRead.onSearchAllOrdersTextChanged,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'search'.tr(),
                                hintStyle: mediumText.copyWith(color: const Color(0xffA6B3BA).withOpacity(0.5), fontSize: 17.sp),
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Image.asset('assets/images/search.png', height: 15, width: 15, color: goSmartBlue),
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      posProviderRead.clearSearchAllOrdersList();
                                      searchController.clear();
                                      FocusScope.of(context).unfocus(); // Dismiss the keyboard
                                    },
                                    child: const Icon(Icons.clear)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 50.w),
                        //*
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/gg.png',
                            height: 50.h,
                            width: 50.w,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'GO Smart ',
                          style: mediumText,
                        ),
                        Text(
                          'POS',
                          style: mediumText.copyWith(color: goSmartBlue),
                        ),
                        //*
                        SizedBox(width: 30.w),
                      ],
                    ),
                  ),
                  //* //*
                  SizedBox(height: 5.h),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  SizedBox(height: 5.h),
                  //* //*
                  //* START OF SESSIONS TREE
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Directionality(
                            textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                            child: Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(width: 20.w),
                                      Text(
                                        'orders'.tr(),
                                        style: boldText.copyWith(fontSize: 18.sp),
                                      ),
                                      const Spacer(),
                                      Badge.count(
                                        largeSize: 20,
                                        textStyle: boldText.copyWith(
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: goSmartBlue,
                                        offset: const Offset(-20, -20),
                                        count: context.watch<PosProvider>().unFinishedReceiptOrders,
                                        child: Text(
                                          'طلبات لم تورد',
                                          style: boldText.copyWith(fontSize: 18.sp),
                                        ),
                                      ),
                                      //* NOT FOR ADMIN
                                      // if (posProviderWatch.loginData.role!.toLowerCase() != 'admin')
                                      //   GestureDetector(
                                      //     behavior: HitTestBehavior.opaque,
                                      //     onTap: () {
                                      //       showDialog(
                                      //           context: context,
                                      //           builder: (context) => AllKioskOrdersDialog(
                                      //                 screenshotControllerKiosk: screenshotControllerKiosk,
                                      //               ));
                                      //     },
                                      //     child: Row(
                                      //       mainAxisAlignment: MainAxisAlignment.start,
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       children: [
                                      //         Text('cash_kiosk_orders'.tr()),
                                      //         Badge.count(
                                      //           largeSize: 20,
                                      //           textStyle: boldText.copyWith(
                                      //             fontSize: 20.sp,
                                      //             color: Colors.white,
                                      //           ),
                                      //           backgroundColor: goSmartBlue,
                                      //           offset: const Offset(10, -10),
                                      //           count: context.watch<PosProvider>().allKioskOrders.data!.length,
                                      //           child: Image.asset(
                                      //             'assets/images/kiosk.png',
                                      //             height: 40.h,
                                      //             width: 40.w,
                                      //             //   color: goSmartBlue,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'filter_by',
                                            style: boldText,
                                          ).tr(),
                                          SizedBox(width: 20.w),
                                          DropdownButton(
                                            value: filterChoice,
                                            items: filters
                                                .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(e.tr()),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              setFilterChoice(value!);

                                              posProviderRead.sortAllSessionOrders(
                                                filterChoice: filterChoice,
                                                sortUp: sortUp,
                                              );
                                            },
                                          ),
                                          SizedBox(width: 20.w),
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  sortUp = !sortUp;

                                                  posProviderRead.sortAllSessionOrders(
                                                    filterChoice: filterChoice,
                                                    sortUp: sortUp,
                                                  );
                                                });
                                              },
                                              child: Icon(sortUp ? Icons.arrow_upward : Icons.arrow_downward,
                                                  color: sortUp ? Colors.green : Colors.red)),
                                        ],
                                      ),
                                      SizedBox(width: 20.w),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.r),
                                        topRight: Radius.circular(10.r),
                                      ),
                                    ),
                                    elevation: 2,
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.symmetric(horizontal: 50.w),
                                              height: 22.h,
                                              width: 20.w,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(3.r),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'order_number'.tr(),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'date'.tr(),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'order_type'.tr(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'total'.tr(),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //* //*
                                  //* //*
                                  SizedBox(height: 10.h),
                                  //* //*
                                  //* //* SEARCH DATA
                                  if (posProviderWatch.isSearching)
                                    //*
                                    Expanded(
                                      child: Scrollbar(
                                        controller: _scrollController,
                                        thumbVisibility: true,
                                        child: ListView.separated(
                                            controller: _scrollController,
                                            separatorBuilder: (context, index) => const Divider(),
                                            itemCount: posProviderWatch.allOrdersSearchResults.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                key: ValueKey(posProviderWatch.allOrdersSearchResults[index].id),
                                                onTap: () {
                                                  searchNode.unfocus();
                                                  log('${posProviderWatch.allOrdersSearchResults[index].id}');
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => OrderDetailsDialog(
                                                            // orderDetails: posProviderWatch.allSessionOrders.data![index],
                                                            index: index,
                                                            sessionId: widget.sessionId,
                                                          ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    SizedBox(width: 5.w),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        margin: EdgeInsets.symmetric(horizontal: 50.w),
                                                        height: 22.h,
                                                        width: 20.w,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(3.r),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          if (posProviderWatch.allOrdersSearchResults[index].isKioskOrder!)
                                                            Image.asset(
                                                              'assets/images/kiosk.png',
                                                              height: 20.h,
                                                              width: 20.w,
                                                            ),
                                                          Text(
                                                            posProviderWatch.allOrdersSearchResults[index].posReference!,
                                                            textAlign: TextAlign.start,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        ez.DateFormat('dd-MM-yyyy hh:mm a')
                                                            .format(posProviderWatch.allOrdersSearchResults[index].dateOrder!),
                                                        textAlign: TextAlign.start,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        posProviderWatch.allOrdersSearchResults[index].paymentData!.isEmpty
                                                            ? ''
                                                            : posProviderWatch
                                                                .allOrdersSearchResults[index].paymentData![0].type!,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        '${posProviderWatch.allOrdersSearchResults[index].amountTotal!.toStringAsFixed(2)} ${'egp'.tr()}',
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    )
                                  //*

                                  else
                                    Expanded(
                                      child: ListView.separated(
                                          separatorBuilder: (context, index) => const Divider(),
                                          itemCount: posProviderWatch.allSessionOrders.data!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              key: ValueKey(posProviderWatch.allSessionOrders.data![index].id),
                                              onTap: () {
                                                log('${posProviderWatch.allSessionOrders.data![index].id}');
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => OrderDetailsDialog(
                                                          // orderDetails: posProviderWatch.allSessionOrders.data![index],
                                                          index: index,
                                                          sessionId: widget.sessionId,
                                                        ));
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  SizedBox(width: 5.w),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      margin: EdgeInsets.symmetric(horizontal: 50.w),
                                                      height: 22.h,
                                                      width: 20.w,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(3.r),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        if (posProviderWatch.allSessionOrders.data![index].isKioskOrder!)
                                                          Image.asset(
                                                            'assets/images/kiosk.png',
                                                            height: 20.h,
                                                            width: 20.w,
                                                          ),
                                                        Text(
                                                          posProviderWatch.allSessionOrders.data![index].posReference!,
                                                          textAlign: TextAlign.start,
                                                          style: (posProviderWatch
                                                                  .allSessionOrders.data![index].invoiceDetails!.isEmpty)
                                                              ? boldText.copyWith(color: Colors.red)
                                                              : null,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      ez.DateFormat('dd-MM-yyyy hh:mm a')
                                                          .format(posProviderWatch.allSessionOrders.data![index].dateOrder!),
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      posProviderWatch.allSessionOrders.data![index].paymentData!.isEmpty
                                                          ? ''
                                                          : posProviderWatch.allSessionOrders.data![index].paymentData![0].type!,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      '${posProviderWatch.allSessionOrders.data![index].amountTotal!.toStringAsFixed(2)} ${'egp'.tr()}',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //* //* KIOSK RECEIPT
              // Positioned(
              //   left: -1000,
              //   child: Screenshot(
              //     controller: screenshotControllerKiosk,
              //     child: Directionality(
              //       textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              //       child: Container(
              //         width: 360,
              //         color: white,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             SizedBox(height: 10.h),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Expanded(
              //                   flex: 3,
              //                   child: Text(
              //                     '${'order_number'.tr()}:   ',
              //                     style: TextStyle(
              //                       fontSize: 18.sp,
              //                       fontWeight: FontWeight.w600,
              //                     ),
              //                   ),
              //                 ),
              //                 Expanded(
              //                   flex: 7,
              //                   child: Text(
              //                     posProviderWatch.latestOrderNumber.toString(),
              //                     style: boldText.copyWith(fontSize: 20.sp),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Expanded(
              //                   flex: 3,
              //                   child: Text(
              //                     '${'date'.tr()}:   ',
              //                     style: TextStyle(
              //                       fontSize: 18.sp,
              //                       fontWeight: FontWeight.w600,
              //                     ),
              //                   ),
              //                 ),
              //                 Expanded(
              //                   flex: 7,
              //                   child: Text(
              //                     ez.DateFormat('E d MMMM yyyy', 'ar').format(DateTime.now()),
              //                     style: mediumText,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Expanded(
              //                   flex: 3,
              //                   child: Text(
              //                     '${'cashier'.tr()}:   ',
              //                     style: TextStyle(
              //                       fontSize: 18.sp,
              //                       fontWeight: FontWeight.w600,
              //                     ),
              //                   ),
              //                 ),
              //                 Expanded(
              //                   flex: 7,
              //                   child: Text(
              //                     posProviderWatch.loginData.name!,
              //                     style: mediumText,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Text(
              //               'Kiosk Order',
              //               textAlign: TextAlign.center,
              //               style: TextStyle(
              //                 fontSize: 18.sp,
              //                 fontWeight: FontWeight.w600,
              //               ),
              //             ),
              //             const Divider(),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.max,
              //               children: [
              //                 Expanded(flex: 1, child: Text('quantity'.tr())),
              //                 const Expanded(flex: 1, child: Text('')),
              //                 Expanded(flex: 2, child: Text('price'.tr())),
              //                 Expanded(flex: 4, child: Text('product_name'.tr())),
              //                 SizedBox(width: 5.w),
              //                 Expanded(
              //                     flex: 2,
              //                     child: Text(
              //                       'total'.tr(),
              //                       maxLines: 1,
              //                     )),
              //               ],
              //             ),
              //             SizedBox(height: 5.h),
              //             ...List.generate(
              //               posProviderWatch.kioskOrdersList.length,
              //               (index) => Padding(
              //                 padding: const EdgeInsets.symmetric(vertical: 3),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Expanded(
              //                         flex: 1,
              //                         child: Text(
              //                           posProviderWatch.kioskOrdersList[index].qty!.toStringAsFixed(0),
              //                           textAlign: TextAlign.center,
              //                         )),
              //                     const Expanded(flex: 1, child: Text('x')),
              //                     Expanded(
              //                         flex: 2,
              //                         child: Text(posProviderWatch.kioskOrdersList[index].priceUnit!.toStringAsFixed(2))),
              //                     Expanded(flex: 4, child: Text(posProviderWatch.kioskOrdersList[index].fullProductName!)),
              //                     SizedBox(width: 5.w),
              //                     Expanded(
              //                         flex: 2,
              //                         child: Text(
              //                           posProviderWatch.kioskOrdersList[index].priceSubtotalIncl!.toStringAsFixed(2),
              //                           maxLines: 1,
              //                         )),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             const Divider(),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Text(
              //                   'total'.tr(),
              //                   style: TextStyle(
              //                     fontSize: 25.sp,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                 ),
              //                 const Spacer(),
              //                 Text(
              //                   '${posProviderWatch.kioskOrderTotal.toStringAsFixed(2)} ${'egp'.tr()}',
              //                   style: mediumText.copyWith(
              //                     fontSize: 25.sp,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(height: 10.h),
              //             Text(
              //               'الاسعار تشمل ضريبة القيمة المضافة',
              //               textAlign: TextAlign.center,
              //               style: mediumText.copyWith(
              //                 fontSize: 15.sp,
              //               ),
              //             ),
              //             SizedBox(height: 10.h),
              //             Text(
              //               'order_reference'.tr(),
              //               textAlign: TextAlign.center,
              //               style: mediumText.copyWith(
              //                 fontSize: 15.sp,
              //               ),
              //             ),
              //             Text(
              //               posProviderWatch.latestOrderRefrence.toString(),
              //               textAlign: TextAlign.center,
              //               style: boldText.copyWith(fontSize: 16.sp),
              //             ),
              //             SizedBox(height: 10.h),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Text(
              //                   'للشكاوى و الاقتراحات',
              //                   style: TextStyle(
              //                     fontSize: 18.sp,
              //                     fontWeight: FontWeight.w600,
              //                   ),
              //                 ),
              //                 const Spacer(),
              //                 Text(
              //                   '01001000111',
              //                   style: mediumText.copyWith(
              //                     fontSize: 18.sp,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             SizedBox(height: 20.h),
              //             Text(
              //               'Powered By gosmart.eg',
              //               textAlign: TextAlign.center,
              //               style: mediumText.copyWith(
              //                 fontSize: 13.sp,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
