import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/all_kiosk_orders_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/balance_input_widget.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/categories_scroller_widget.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/add_new_pos_session_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/main.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pos_windows_ice_hub/widget/usb_printer_setup_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../styles/text_style.dart';
import '../dialogs/customize_product_dialog.dart';

//* VFD
const platform = MethodChannel('vfd.serial/connection');

// Future<void> sendText(String text) async {
//   try {
//     final result = await platform.invokeMethod('sendToVFD', {"text": text});
//     print("✅ \$result");
//   } catch (e) {
//     print("❌ Failed to send: \$e");
//   }
// }

class MenuMiddleWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> drawerKey;

  const MenuMiddleWidget({super.key, required this.drawerKey});

  @override
  State<MenuMiddleWidget> createState() => _MenuMiddleWidgetState();
}

class _MenuMiddleWidgetState extends State<MenuMiddleWidget> {
  final searchController = TextEditingController();
  final searchNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  //* uncomment for second screen
  // DisplayManager displayManager = DisplayManager();
  List<Display?> displays = [];
  //*
  bool dataLoaded = false;
  int selectedCategoryIndex = 0; // Track selected category
  // bool _dialogShown = true; // Flag to track if the dialog has been shown

  // void showSecondryDisplay() async {
  //   //* GET DISPLAYS
  //   final values = await displayManager.getDisplays();
  //   displays.clear();

  //   displays.addAll(values!);

  //   Map<String, dynamic> selectedScreenData = {};

  //   for (var element in displays) {
  //     print('ID: ${element!.displayId} -- FLAG: ${element.flag} -- NAME: ${element.name} -- ROTATION: ${element.rotation}');

  //     if (element.name == 'HDMI Screen') {
  //       selectedScreenData = {'id': element.displayId, 'name': element.name};
  //     }
  //   }
  //   //*
  //   //*
  //   if (values.length > 1) {
  //     Navigation().showLoadingGifDialog(context);
  //     //*
  //     displayManager.showSecondaryDisplay(displayId: selectedScreenData['id'], routerName: "cart");
  //     //*
  //     Navigation().closeDialog(context);
  //   }
  // }

  //*

  void initDate() {
    try {
      Future.microtask(() async {
        await Future.wait([
          context.read<MenuProvider>().getAllCategories().then((value) async {
            await context.read<MenuProvider>().getCategoryProducts(
                context.read<MenuProvider>().firstSelectedCategory);
          }),
          PosApis().getCustomerID().then((cusId) {
            context.read<PosProvider>().setCustomerId = cusId!;
          }),
          context.read<PosProvider>().getAvailablePaymentMethods(),
          context.read<PosProvider>().getCurrentSessionData(posId),
          context.read<MenuProvider>().getDiscountData(),
          context.read<MenuProvider>().getAllProducts(),
          context
              .read<PosProvider>()
              .checkForActiveSessions(
                  posId, context.read<PosProvider>().loginData.userId!)
              .then((dataMap) {
            bool hasActiveSession = dataMap['has_active_session'];
            bool sameUser = dataMap['same_user'];

            if (hasActiveSession && sameUser) {
              print('11 → continue same session');
            } else if (hasActiveSession && sameUser == false) {
              print('22 → new session with another user');
            } else {
              print('33 → start new session');
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const BalanceInputWidget(),
              );
            }
          }),
        ]);
//*Mahmoud
        final prefs = await SharedPreferences.getInstance();
        final savedPrinter = prefs.getString('printerName') ?? "";

        if (savedPrinter.isEmpty ||
            context.read<PosProvider>().printName.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: SizedBox(
                height: AppDimentions().availableheightNoAppBar * 0.8,
                width: AppDimentions().availableWidth * 0.8,
                child: const Column(
                  children: [
                    Expanded(
                        child: USBPrinterSetupWidget(
                      isFromSettings: false,
                    ))
                  ],
                ),
              ),
            ),
          );
        } else {
          // Optional: Auto-connect to the saved printer here
          print(" Printer already saved: $savedPrinter");
        }

        dataLoaded = true;
        setState(() {});
      });
    } catch (e) {
      print('❌ Error initializing data: $e');
      initDate();
    }
  }

  @override
  void initState() {
    super.initState();
    initDate();
  }

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    // print(AppDimentions().availableheightWithAppBar);
    // print(AppDimentions().availableWidth);

    final menuProviderRead = context.read<MenuProvider>();
    final menuProviderWatch = context.watch<MenuProvider>();

    final posProviderRead = context.read<PosProvider>();
    final posProviderWatch = context.watch<PosProvider>();

    return Container(
      child: dataLoaded
          ? DefaultTabController(
              length: menuProviderWatch.categories.data!.length,
              initialIndex: 0,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height:
                              AppDimentions().availableheightNoAppBar * 0.135,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: TextField(
                                    controller: searchController,
                                    focusNode: searchNode,
                                    enabled: true,
                                    onChanged:
                                        menuProviderRead.onSearchTextChanged,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'search'.tr(),
                                      hintStyle: mediumText.copyWith(
                                        color: const Color(0xffA6B3BA)
                                            .withOpacity(0.5),
                                        fontSize: 17.sp,
                                      ),

                                      // border: textBorder,
                                      // errorBorder: textBorder,
                                      // enabledBorder: textBorder,
                                      // focusedBorder: textBorder,
                                      border: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 6),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Image.asset(
                                            'assets/images/search.png',
                                            height: 15,
                                            width: 15,
                                            color: goSmartBlue),
                                      ),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            menuProviderRead.clearSearchList();
                                            searchController.clear();
                                            FocusScope.of(context)
                                                .unfocus(); // Dismiss the keyboard
                                          },
                                          child: const Icon(Icons.clear)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigation()
                                            .showLoadingGifDialog(context);
                                        //*
                                        // await displayManager.showSecondaryDisplay(displayId: 1, routerName: "cart");
                                        //*
                                        Navigation().closeDialog(context);
                                      },
                                      onDoubleTap: () async {
                                        Navigation()
                                            .showLoadingGifDialog(context);
                                        //*
                                        // await displayManager.hideSecondaryDisplay(displayId: 1);
                                        //*
                                        Navigation().closeDialog(context);
                                      },
                                      child: Text(
                                        posProviderRead.loginData.name!,
                                        style: boldText.copyWith(
                                            color: Colors.grey[400],
                                            fontSize: 18.sp),
                                      ),
                                    ),
                                    //    SizedBox(height: 5.h),
                                    Text(
                                      posProviderRead.loginData.role ==
                                              'Cashier'
                                          ? 'cashier'.tr()
                                          : 'admin'.tr(),
                                      style: boldText.copyWith(
                                          color: Colors.grey[350],
                                          fontSize: 15.sp),
                                    ),
                                    //     SizedBox(height: 5.h),
                                    Text(
                                      intl.DateFormat('E d MMMM yyyy', 'ar')
                                          .format(DateTime.now()),
                                      style: boldText.copyWith(
                                          color: Colors.grey[400],
                                          fontSize: 17.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 50.w),
                              GestureDetector(
                                onTap: () {
                                  //  showDialog(context: context, builder: (context) => const BalanceInputWidget());

                                  widget.drawerKey.currentState!
                                      .openEndDrawer();
                                },
                                child:
                                    Icon(Icons.menu, color: Colors.grey[500]),
                              ),
                              SizedBox(width: 30.w),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        const Divider(indent: 20, endIndent: 20),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      height: 120.h,
                                      child: const CategoriesScrollerWidget()),
                                  const SizedBox(height: 20),
                                  if (menuProviderWatch.menuItemsLoaded)
                                    Expanded(
                                      child: Scrollbar(
                                        controller: _scrollController,
                                        thumbVisibility: true,
                                        trackVisibility: true,
                                        thickness: 6,
                                        radius: const Radius.circular(10),
                                        child: GridView.builder(
                                          controller: _scrollController,
                                          itemCount: menuProviderWatch
                                              .selectedProductsList
                                              .data!
                                              .length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                            //  childAspectRatio: 1.w,
                                            childAspectRatio: 1.5.w,
                                          ),
                                          itemBuilder: (context, index) {
                                            //* Check if the product is available
                                            if (menuProviderWatch
                                                    .selectedProductsList
                                                    .data![index]
                                                    .qtyAvailable! <=
                                                0) {
                                              return Stack(
                                                children: [
                                                  Container(
                                                    key: ValueKey(
                                                        menuProviderWatch
                                                            .selectedProductsList
                                                            .data![index]
                                                            .id),
                                                    decoration: BoxDecoration(
                                                      color: white,
                                                      border: Border.all(
                                                        // color: goSmartBlue
                                                        color: Colors.grey
                                                            .withAlpha(200),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(height: 30.h),
                                                        // ClipRRect(
                                                        //   borderRadius: BorderRadiusGeometry.circular(8),
                                                        //   child: CachedNetworkImage(
                                                        //     cacheKey: menuProviderWatch.selectedProductsList.data![index].name,
                                                        //     height: 100.h,
                                                        //     width: 100.w,
                                                        //     fit: BoxFit.cover,
                                                        //     imageUrl: menuProviderWatch.selectedProductsList.data![index].image!,
                                                        //     progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                        //       child: CircularProgressIndicator(
                                                        //         value: downloadProgress.progress,
                                                        //         color: goSmartBlue,
                                                        //       ),
                                                        //     ),
                                                        //     errorWidget: (context, url, error) => const Icon(Icons.error),
                                                        //   ),
                                                        // ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: Text(
                                                            context.locale ==
                                                                    const Locale(
                                                                        'ar')
                                                                ? menuProviderWatch
                                                                        .selectedProductsList
                                                                        .data![
                                                                            index]
                                                                        .nameAr!
                                                                        .isEmpty
                                                                    ? menuProviderWatch
                                                                        .selectedProductsList
                                                                        .data![
                                                                            index]
                                                                        .name!
                                                                    : menuProviderWatch
                                                                        .selectedProductsList
                                                                        .data![
                                                                            index]
                                                                        .nameAr!
                                                                : menuProviderWatch
                                                                    .selectedProductsList
                                                                    .data![
                                                                        index]
                                                                    .name!,
                                                            //  menuProviderWatch.selectedProductsList.data![index].name!,
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            // SizedBox(width: 25.w),
                                                            Text(
                                                              menuProviderWatch
                                                                  .selectedProductsList
                                                                  .data![index]
                                                                  .listPrice!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            Text(
                                                              '  ${'egp'.tr()}',
                                                              style: GoogleFonts
                                                                  .roboto(
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            // const Spacer(),
                                                            // Image.asset(
                                                            //   'assets/images/cart.png',
                                                            //   height: 20,
                                                            //   width: 20,
                                                            // ),
                                                            // SizedBox(width: 25.w),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5.h),
                                                      ],
                                                    ),
                                                  ),
                                                  //* //*
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey
                                                            .withAlpha(200),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15.r),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  15.r),
                                                        ),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'out_of_stock'.tr(),
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return GestureDetector(
                                                onTap: () async {
                                                  print(
                                                    '${menuProviderWatch.selectedProductsList.data![index].id} -- ${menuProviderWatch.selectedProductsList.data![index].name}',
                                                  );

                                                  await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) =>
                                                        CustomizeProductDialog(
                                                      //*
                                                      isOthers: menuProviderWatch
                                                              .selectedProductsList
                                                              .data![index]
                                                              .name!
                                                              .toLowerCase() ==
                                                          'others',
                                                      //*
                                                      isEdit: false,
                                                      key: ValueKey(
                                                          menuProviderWatch
                                                              .selectedProductsList
                                                              .data![index]
                                                              .id),
                                                      productId: menuProviderWatch
                                                          .selectedProductsList
                                                          .data![index]
                                                          .id!,
                                                      name: menuProviderWatch
                                                          .selectedProductsList
                                                          .data![index]
                                                          .name!,
                                                      nameAr: menuProviderWatch
                                                          .selectedProductsList
                                                          .data![index]
                                                          .nameAr!,
                                                      image: menuProviderWatch
                                                          .selectedProductsList
                                                          .data![index]
                                                          .image!,
                                                      quantityAvailable:
                                                          menuProviderWatch
                                                              .selectedProductsList
                                                              .data![index]
                                                              .qtyAvailable!,
                                                      //  price: menuProviderWatch.selectedProductsList.data![index].listPrice!,
                                                      taxesId: menuProviderWatch
                                                          .selectedProductsList
                                                          .data![index]
                                                          .taxesId!,
                                                      description:
                                                          menuProviderWatch
                                                              .selectedProductsList
                                                              .data![index]
                                                              .description!,
                                                      descriptionAr:
                                                          menuProviderWatch
                                                              .selectedProductsList
                                                              .data![index]
                                                              .descriptionAr!,

                                                      //* //*
                                                      // displayManager: displayManager,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  key: ValueKey(
                                                      menuProviderWatch
                                                          .selectedProductsList
                                                          .data![index]
                                                          .id),
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border.all(
                                                        color: goSmartBlue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(height: 30.h),
                                                      if (menuProviderWatch
                                                              .selectedProductsList
                                                              .data![index]
                                                              .name!
                                                              .toLowerCase() ==
                                                          'others')
                                                        SizedBox(height: 30.h),
                                                      // CachedNetworkImage(
                                                      //   cacheKey: menuProviderWatch.selectedProductsList.data![index].name,
                                                      //   height: menuProviderWatch.selectedProductsList.data![index].name!
                                                      //               .toLowerCase() ==
                                                      //           'others'
                                                      //       ? 70.h
                                                      //       : 100.h,
                                                      //   width: menuProviderWatch.selectedProductsList.data![index].name!
                                                      //               .toLowerCase() ==
                                                      //           'others'
                                                      //       ? 70.w
                                                      //       : 100.w,
                                                      //   fit: menuProviderWatch.selectedProductsList.data![index].name!
                                                      //               .toLowerCase() ==
                                                      //           'others'
                                                      //       ? BoxFit.contain
                                                      //       : BoxFit.cover,
                                                      //   color: menuProviderWatch.selectedProductsList.data![index].name!
                                                      //               .toLowerCase() ==
                                                      //           'others'
                                                      //       ? Colors.grey.withOpacity(0.5)
                                                      //       : null,
                                                      //   imageUrl: menuProviderWatch.selectedProductsList.data![index].image!,
                                                      //   progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                      //     child: CircularProgressIndicator(
                                                      //       value: downloadProgress.progress,
                                                      //       color: goSmartBlue,
                                                      //     ),
                                                      //   ),
                                                      //   errorWidget: (context, url, error) => const Icon(Icons.error),
                                                      // ),

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 5),
                                                        child: Text(
                                                          context.locale ==
                                                                  const Locale(
                                                                      'ar')
                                                              ? menuProviderWatch
                                                                      .selectedProductsList
                                                                      .data![
                                                                          index]
                                                                      .nameAr!
                                                                      .isEmpty
                                                                  ? menuProviderWatch
                                                                      .selectedProductsList
                                                                      .data![
                                                                          index]
                                                                      .name!
                                                                  : menuProviderWatch
                                                                      .selectedProductsList
                                                                      .data![
                                                                          index]
                                                                      .nameAr!
                                                              : menuProviderWatch
                                                                  .selectedProductsList
                                                                  .data![index]
                                                                  .name!,
                                                          //  menuProviderWatch.selectedProductsList.data![index].name!,
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          // SizedBox(width: 25.w),
                                                          Text(
                                                            menuProviderWatch
                                                                .selectedProductsList
                                                                .data![index]
                                                                .listPrice!
                                                                .toStringAsFixed(
                                                                    2),
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  goSmartBlue,
                                                            ),
                                                          ),
                                                          Text(
                                                            '  ${'egp'.tr()}',
                                                            style: GoogleFonts
                                                                .roboto(
                                                              fontSize: 13.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  goSmartBlue,
                                                            ),
                                                          ),
                                                          // const Spacer(),
                                                          // Image.asset(
                                                          //   'assets/images/cart.png',
                                                          //   height: 20,
                                                          //   width: 20,
                                                          // ),
                                                          // SizedBox(width: 25.w),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.h),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  else if (menuProviderWatch.menuItemsError ==
                                      false)
                                    const CircularProgressIndicator(
                                        color: goSmartBlue)
                                  else
                                    const Text('حدث خطأ برجاء اعاده التحميل'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //* //* //* //* //*
                  //* //* //* //* //*
                  //* SEARCH RESULT WIDGET
                  if (menuProviderWatch.isSearching &&
                      menuProviderWatch.searchResult.isNotEmpty)
                    Positioned(
                        top: AppDimentions().availableheightNoAppBar * 0.135,
                        left: 25.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              height:
                                  AppDimentions().availableheightWithAppBar *
                                      0.5,
                              width: AppDimentions().availableWidth * 0.39,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withAlpha(100), // Glass transparency
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.white.withAlpha(150),
                                ),
                              ),
                              child: ListView.builder(
                                  itemCount:
                                      menuProviderWatch.searchResult.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () async {
                                          print(
                                              'productId: ${menuProviderWatch.searchResult[index].id} -- name: ${menuProviderWatch.searchResult[index].name}');

                                          if (menuProviderWatch
                                                  .searchResult[index]
                                                  .qtyAvailable! >
                                              0) {
                                            //*
                                            searchController.clear();
                                            searchNode.unfocus();
                                            //*
                                            await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) =>
                                                  CustomizeProductDialog(
                                                //*
                                                isOthers: menuProviderWatch
                                                        .searchResult[index]
                                                        .name!
                                                        .toLowerCase() ==
                                                    'others',
                                                //*
                                                isEdit: false,
                                                key: ValueKey(menuProviderWatch
                                                    .searchResult[index].id),
                                                productId: menuProviderWatch
                                                    .searchResult[index].id!,
                                                name: menuProviderWatch
                                                    .searchResult[index].name!,
                                                nameAr: menuProviderWatch
                                                    .searchResult[index]
                                                    .nameAr!,
                                                image: menuProviderWatch
                                                    .searchResult[index].image!,
                                                quantityAvailable:
                                                    menuProviderWatch
                                                        .searchResult[index]
                                                        .qtyAvailable!,

                                                taxesId: menuProviderWatch
                                                    .searchResult[index]
                                                    .taxesId!,

                                                description: menuProviderWatch
                                                    .searchResult[index]
                                                    .description!,
                                                descriptionAr: menuProviderWatch
                                                    .searchResult[index]
                                                    .descriptionAr!,

                                                //* //*
                                                // displayManager: displayManager,
                                              ),
                                            );

                                            //*
                                            menuProviderRead.clearSearchList();

                                            //*
                                          }
                                        },
                                        child: Container(
                                          key: ValueKey(menuProviderWatch
                                              .searchResult[index].id),
                                          padding: const EdgeInsets.all(3),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              color: white.withAlpha(200),
                                              border: Border.all(
                                                  color: white, width: 3)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                menuProviderWatch
                                                    .searchResult[index]
                                                    .nameAr!,
                                                style: mediumText.copyWith(
                                                  color: menuProviderWatch
                                                              .searchResult[
                                                                  index]
                                                              .qtyAvailable! <=
                                                          0
                                                      ? Colors.grey
                                                      : black,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Container(
                                                height: 50.h,
                                                width: 50.w,
                                                padding:
                                                    const EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    color: goSmartBlue
                                                        .withAlpha(50)),
                                                child: CachedNetworkImage(
                                                  height: 50.h,
                                                  width: 50.w,
                                                  imageUrl: menuProviderWatch
                                                      .searchResult[index]
                                                      .image!,
                                                  cacheKey: menuProviderWatch
                                                      .searchResult[index].name,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                            ),
                          ),
                        ))
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator(color: goSmartBlue)),
    );
  }
}
