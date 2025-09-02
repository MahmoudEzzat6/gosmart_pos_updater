import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/session_side_menu_widget.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/views/all_open_cheques_screen.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../menu_cart_cycle.dart/widgets/menu_middle_widget.dart';
import '../../menu_cart_cycle.dart/widgets/right_cart_widget.dart';

class HomeScreen extends StatelessWidget {
  final bool isAdmin;

  HomeScreen({super.key, required this.isAdmin});

  final GlobalKey<ScaffoldState> _drawerKeyInHome = GlobalKey();

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final posProviderRead = context.read<PosProvider>();
    final posProviderWatch = context.watch<PosProvider>();

    final menuProviderWatch = context.watch<MenuProvider>();

    final openChequeProviderRead = context.read<OpenChequeProvider>();
    final openChequeProviderWatch = context.watch<OpenChequeProvider>();

    return SafeArea(
      top: true,
      child: Scaffold(
        key: _drawerKeyInHome,
        endDrawer: const SessionSideMenuWidget(),
        backgroundColor: bgColor,
        body: SizedBox(
          height: AppDimentions().availableheightWithAppBar,
          width: AppDimentions().availableWidth,
          child: Stack(
            children: [
              SizedBox(
                height: AppDimentions().availableheightWithAppBar,
                width: AppDimentions().availableWidth,
                child: Column(
                  children: [
                    IndexedStack(
                      index: openChequeProviderWatch.isOpenCheque ? 1 : 0,
                      children: [
                        SizedBox(
                          height: AppDimentions().availableheightWithAppBar,
                          width: AppDimentions().availableWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              //* //* //* //* RIGHT SIDE
                              SizedBox(
                                height:
                                    AppDimentions().availableheightWithAppBar,
                                width: AppDimentions().availableWidth * 0.35,
                                child: RightCartWidget(
                                  screenshotController: screenshotController,
                                  isCustomer: false,
                                  isAdmin: isAdmin,
                                ),
                              ),

                              //* //* //* //*
                              //* //* //* //*
                              //* //* //* //*
                              //* //* //* //* MIDDLE AND RIGHT >> MENU

                              SizedBox(
                                height:
                                    AppDimentions().availableheightWithAppBar,
                                width: AppDimentions().availableWidth * 0.65,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      height: AppDimentions()
                                          .availableheightWithAppBar,
                                      width: 1.w,
                                      color: const Color.fromRGBO(
                                          225, 225, 225, 1),
                                    ),
                                    Expanded(
                                        child: MenuMiddleWidget(
                                            drawerKey: _drawerKeyInHome)),
                                    Container(
                                      height: AppDimentions()
                                          .availableheightWithAppBar,
                                      width: 1.w,
                                      color: const Color.fromRGBO(
                                          225, 225, 225, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //* //*
                        SizedBox(
                          height: AppDimentions().availableheightWithAppBar,
                          width: AppDimentions().availableWidth,
                          child: AllOpenChequesScreen(
                            isAdmin: isAdmin,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //* //* //* //*
              Positioned(
                left: -1000,
                child: Screenshot(
                  controller: screenshotController,
                  child: Directionality(
                    textDirection: context.locale.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Container(
                      width: 360,
                      padding: const EdgeInsets.all(3),
                      color: white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'ICE   CREAM   HUB',
                            textAlign: TextAlign.center,
                            style: boldText.copyWith(
                                fontSize: 22,
                                fontFamily: GoogleFonts.monoton().fontFamily),
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
                                  style: const TextStyle(
                                    fontSize: 16,
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
                                    posProviderWatch.latestOrderNumber
                                        .toString(),
                                    style: boldText.copyWith(fontSize: 40),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            intl.DateFormat(
                                                    'E d MMMM yyyy', 'ar')
                                                .format(DateTime.now()),
                                            style: mediumText.copyWith(
                                                fontSize: 14),
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
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            intl.DateFormat('hh:mm a', 'ar')
                                                .format(DateTime.now()),
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Text(
                                  posProviderRead.loginData.name!,
                                  style: mediumText,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            menuProviderWatch.selectedOrderType == 'Take Away'
                                ? 'take_away'.tr()
                                : menuProviderWatch.selectedOrderType ==
                                        'Dine In'
                                    ? 'dine_in'.tr()
                                    : 'delivery'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //* IF DELIVERY USER
                          if (menuProviderWatch.selectedOrderType
                                      .toLowerCase() ==
                                  'delivery' &&
                              context
                                  .watch<PosProvider>()
                                  .deliveryUsers
                                  .data!
                                  .isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'اسم العميل   : ${context.watch<PosProvider>().deliveryUsers.data![0].name}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'التليفون        : ${context.watch<PosProvider>().deliveryUsers.data![0].phone}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'العنوان          : ${context.watch<PosProvider>().deliveryUsers.data![0].address}',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                      style: mediumText.copyWith(
                                          color: black, fontSize: 12),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      'quantity'.tr(),
                                      textAlign: TextAlign.center,
                                      style: mediumText.copyWith(
                                          color: black, fontSize: 12),
                                      maxLines: 1,
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'price'.tr(),
                                      textAlign: TextAlign.center,
                                      style: mediumText.copyWith(
                                          color: black, fontSize: 12),
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
                                      style: mediumText.copyWith(
                                          color: black, fontSize: 12),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ...List.generate(
                            menuProviderWatch.cartItems.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: Text(
                                        menuProviderWatch
                                            .cartItems[index].productName,
                                        style: boldText.copyWith(fontSize: 22),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        menuProviderWatch
                                            .cartItems[index].quantity
                                            .toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: boldText,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        menuProviderWatch
                                            .cartItems[index].priceUnit
                                            .toStringAsFixed(2),
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
                                        (menuProviderWatch.cartItems[index]
                                                    .priceUnit *
                                                menuProviderWatch
                                                    .cartItems[index].quantity)
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
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${menuProviderWatch.cartSubtotal.toStringAsFixed(2)} ${'egp'.tr()}',
                                style: mediumText.copyWith(
                                  color: black,
                                  fontSize: 17,
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
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${menuProviderWatch.taxTotal.toStringAsFixed(2)} ${'egp'.tr()}',
                                style: mediumText.copyWith(
                                  color: black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'total'.tr(),
                                style: const TextStyle(
                                  fontSize: 23,
                                  color: black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${menuProviderWatch.cartTotal.toStringAsFixed(2)} ${'egp'.tr()}',
                                style: mediumText.copyWith(
                                  color: black,
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'الاسعار تشمل ضريبة القيمة المضافة',
                            textAlign: TextAlign.center,
                            style: mediumText.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'order_reference'.tr(),
                            textAlign: TextAlign.center,
                            style: mediumText.copyWith(
                              fontSize: 15,
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  border: Border.all(color: black)),
                              child: Text(
                                posProviderWatch.latestOrderRefrence.toString(),
                                textAlign: TextAlign.center,
                                style: boldText.copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 20),
                          Container(
                            color: black,
                            child: Text(
                              'Powered By GO Smart',
                              textAlign: TextAlign.center,
                              style: mediumText.copyWith(
                                color: white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            'www.gosmart.eg',
                            textAlign: TextAlign.center,
                            style: mediumText.copyWith(
                              color: black,
                              fontSize: 13,
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
