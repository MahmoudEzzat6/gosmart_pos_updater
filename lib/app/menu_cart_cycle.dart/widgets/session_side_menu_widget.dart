import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/views/login_screen.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/views/all_session_orders_screen.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/views/pos_setting.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/close_session_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/session_details_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/localized_helper.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/main.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:pos_windows_ice_hub/widget/usb_printer_setup_widget.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:provider/provider.dart';

class SessionSideMenuWidget extends StatefulWidget {
  const SessionSideMenuWidget({super.key});

  @override
  State<SessionSideMenuWidget> createState() => _SessionSideMenuWidgetState();
}

class _SessionSideMenuWidgetState extends State<SessionSideMenuWidget> {
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<PosProvider>().getCurrentSessionData(posId);

      dataLoaded = true;

      log('''
          PosID: ${context.read<PosProvider>().currentSession.data![0].posId}
          sessionID: ${context.read<PosProvider>().currentSession.data![0].id}
          sessionName: ${context.read<PosProvider>().currentSession.data![0].name}
          CashierID: ${context.read<PosProvider>().currentSession.data![0].cashierId}
          ''');

      await context.read<PosProvider>().getAllSessionOrders(
          context.read<PosProvider>().currentSession.data![0].id!);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final posProviderWatch = context.watch<PosProvider>();

    final openChequeProviderWatch = context.watch<OpenChequeProvider>();
    final openChequeProviderRead = context.read<OpenChequeProvider>();

    return Drawer(
      child: SizedBox(
        width: AppDimentions().availableWidth * 0.3,
        height: AppDimentions().availableheightWithAppBar,
        child: dataLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      // //*
                      // context.read<MenuProvider>().resetAfterFinishOrder(context);
                      // //*
                      // Navigation().goToScreenAndClearAll(context, (context) => const LoginScreen());
                    },
                    child: Text(
                      posProviderWatch.currentSession.data![0].posName!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const Divider(),
                  SizedBox(height: 10.h),
                  MenuDataRow(
                    label: 'session_name'.tr(),
                    data: posProviderWatch.currentSession.data![0].name!,
                  ),
                  SizedBox(height: 10.h),
                  MenuDataRow(
                    label: 'start_time'.tr(),
                    data: DateFormat('yyyy/MM/dd - hh:mm a',
                            context.localizedValue(en: 'en', ar: 'ar'))
                        .format(
                            posProviderWatch.currentSession.data![0].startAt!),
                  ),
                  SizedBox(height: 10.h),
                  MenuDataRow(
                    label: 'notes'.tr(),
                    data:
                        posProviderWatch.currentSession.data![0].openingNotes!,
                  ),
                  SizedBox(height: 10.h),
                  const Divider(),
                  SizedBox(height: 10.h),
                  MenuDataRow(
                    label: 'orders_number'.tr(),
                    data: posProviderWatch.currentSession.data![0].ordersCount!
                        .toString(),
                  ),
                  SizedBox(height: 10.h),
                  MenuDataRow(
                    label: 'total_cash'.tr(),
                    data:
                        '${'egp'.tr()} ${posProviderWatch.currentSession.data![0].totalPaymentsAmount!.toStringAsFixed(2)}',
                  ),
                  //* //* //*
                  SizedBox(height: 30.h),
                  TextButton(
                      onPressed: () async {
                        Navigation().showLoadingGifDialog(context);

                        try {
                          await context.read<PosProvider>().getAllSessionOrders(
                              context
                                  .read<PosProvider>()
                                  .currentSession
                                  .data![0]
                                  .id!);

                          await context.read<PosProvider>().getAllKioskOrders(
                              context
                                  .read<PosProvider>()
                                  .currentSession
                                  .data![0]
                                  .id!);

                          Navigation().closeDialog(context);

                          Navigation().goToScreen(
                              context,
                              (context) => AllSessionOrdersScreen(
                                    cashierName: context
                                        .read<PosProvider>()
                                        .currentSession
                                        .data![0]
                                        .cashierName!,
                                    sessionId: context
                                        .read<PosProvider>()
                                        .currentSession
                                        .data![0]
                                        .id!,
                                  ));
                        } catch (e) {
                          print('Error fetching orders: $e');
                          Navigation().closeDialog(context);

                          showDialog(
                              context: context,
                              builder: (context) => OkDialog(
                                    text: 'حدث خطأ أثناء جلب الطلبات:',
                                    onPressed: () {
                                      Navigation().closeDialog(context);
                                    },
                                  ));
                        }
                      },
                      child: Text(
                        'show_all_orders'.tr(),
                        style: mediumText.copyWith(
                          color: goSmartBlue,
                        ),
                      )),
                  //* //*
                  SizedBox(height: 40.h),
                  //* //*
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        // height: 50.h,
                        width: 150.w,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                openChequeProviderWatch.isOpenCheque
                                    ? goSmartBlue
                                    : white),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                          onPressed: () {
                            openChequeProviderRead.openCheque();
                          },
                          child: Text(
                            'شيك مفتوح',
                            style: mediumText.copyWith(
                              fontSize: 18.sp,
                              color: openChequeProviderWatch.isOpenCheque
                                  ? white
                                  : goSmartBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        // height: 50.h,
                        width: 150.w,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                openChequeProviderWatch.isOpenCheque
                                    ? white
                                    : goSmartBlue),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                          onPressed: () {
                            openChequeProviderRead.closeCheque();
                          },
                          child: Text(
                            'شيك مغلق',
                            style: mediumText.copyWith(
                              fontSize: 18.sp,
                              color: openChequeProviderWatch.isOpenCheque
                                  ? goSmartBlue
                                  : white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () async {
                        Navigation().goToScreen(
                            //*Mahmoud
                            context,
                            (context) => const PosSettingsScreen());
                        // showDialog(
                        //     context: context,
                        //     builder: (context) => AlertDialog(
                        //           content: SizedBox(
                        //             height: AppDimentions()
                        //                     .availableheightNoAppBar *
                        //                 0.8,
                        //             width: AppDimentions().availableWidth * 0.8,
                        //             child: const Column(
                        //               children: [
                        //                 Expanded(
                        //                     child: USBPrinterSetupWidget(
                        //                   isFromSettings: true,
                        //                 ))
                        //               ],
                        //             ),
                        //           ),
                        //         ));
                      },
                      child: Text(
                        'settings'.tr(),
                        style: mediumText.copyWith(
                          color: goSmartBlue,
                        ),
                      )),
                  //* //*

                  //* //* //*
                  //* //* //*

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BlueButton(
                        label: 'close_shift'.tr(),
                        onPressed: () async {
                          print('hello');
                          if (context
                                  .read<PosProvider>()
                                  .unFinishedReceiptOrders >
                              0) {
                            showDialog(
                                context: context,
                                builder: (context) => YesNoDialog(
                                    dialogText:
                                        'يوجد لديك فواتير غير موردة.\nهل تريد المتابعة فى اغلاق الشيفت ؟',
                                    onYesPressed: () async {
                                      Navigation()
                                          .showLoadingGifDialog(context);

                                      //*
                                      await PosApis()
                                          .getClosingSessionData(context
                                              .read<PosProvider>()
                                              .currentSession
                                              .data![0]
                                              .id!)
                                          .then((closingSessionData) {
                                        //*
                                        //*
                                        Navigation().closeDialog(context);
                                        //*
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CloseSessionDialog(
                                                    closingSessionData:
                                                        closingSessionData!,
                                                    //*
                                                    isAdmin: false,
                                                    //*
                                                    sessionId: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .id!,
                                                    posName: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .posName!,
                                                    sessionName: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .name!,
                                                    cashierName: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .cashierName!,
                                                    openingCash: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .openingCash!,
                                                    closingCash: 0.0,
                                                    state: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .state!,
                                                    startAt: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .startAt!
                                                        .toString(),
                                                    closeAt: DateTime.now()
                                                        .toString(),
                                                    openingNote: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .openingNotes!,
                                                    orderCount: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .ordersCount!,
                                                    totalPaymentsAmount: context
                                                        .read<PosProvider>()
                                                        .currentSession
                                                        .data![0]
                                                        .totalPaymentsAmount!,
                                                    closingNote:
                                                        'closingNote'));
                                      });
                                    },
                                    onNoPressed: () {
                                      Navigation().closeDialog(context);
                                    }));
                          } else {
                            Navigation().showLoadingGifDialog(context);

                            //*
                            await PosApis()
                                .getClosingSessionData(context
                                    .read<PosProvider>()
                                    .currentSession
                                    .data![0]
                                    .id!)
                                .then((closingSessionData) {
                              //*
                              //*
                              Navigation().closeDialog(context);
                              //*
                              showDialog(
                                  context: context,
                                  builder: (context) => CloseSessionDialog(
                                      closingSessionData: closingSessionData!,
                                      //*
                                      isAdmin: false,
                                      //*
                                      sessionId: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .id!,
                                      posName: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .posName!,
                                      sessionName: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .name!,
                                      cashierName: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .cashierName!,
                                      openingCash: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .openingCash!,
                                      closingCash: 0.0,
                                      state: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .state!,
                                      startAt: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .startAt!
                                          .toString(),
                                      closeAt: DateTime.now().toString(),
                                      openingNote: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .openingNotes!,
                                      orderCount: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .ordersCount!,
                                      totalPaymentsAmount: context
                                          .read<PosProvider>()
                                          .currentSession
                                          .data![0]
                                          .totalPaymentsAmount!,
                                      closingNote: 'closingNote'));
                            });
                          }
                        }),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: goSmartBlue,
                ),
              ),
      ),
    );
  }
}

class MenuDataRow extends StatelessWidget {
  final String label;
  final String data;

  const MenuDataRow({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              data,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              flex: 4,
              child: Text(
                label,
                textAlign: TextAlign.end,
              )),
        ],
      ),
    );
  }
}
