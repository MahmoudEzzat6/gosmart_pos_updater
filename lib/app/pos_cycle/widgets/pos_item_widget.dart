import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/close_session_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/delete_pos_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/edit_pos_session_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/views/all_sessions_screen.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/views/home_screen.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PosItemWidget extends StatelessWidget {
  final int id;
  final String name;
  final bool isActive;
  final bool hasActiveSession;
  final String currentSession;
  final int currentSessionId;
  final String lastSessionClosingDate;
  final double lastSessionClosingCash;
  final String lastSessionUsername;
  final String lastSessionState;
  final String lastSessionDuration;

  const PosItemWidget(
      {super.key,
      required this.id,
      required this.name,
      required this.isActive,
      required this.hasActiveSession,
      required this.currentSession,
      required this.currentSessionId,
      required this.lastSessionClosingDate,
      required this.lastSessionClosingCash,
      required this.lastSessionUsername,
      required this.lastSessionState,
      required this.lastSessionDuration});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: const BorderSide(
          color: Color(0xffFFDFBD),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          // border: Border.all(
          //   color: const Color(0xffFFDFBD),
          // ),
          gradient: const LinearGradient(
            colors: [
              Color(0xffFEF2E7),
              Color(0xffFBFBFB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: mediumText,
                  ),
                ),
                // const Spacer(),
                GestureDetector(
                  onTap: () async {
                    Navigation().showLoadingGifDialog(context);
                    //*
                    await context.read<PosProvider>().getPosSessions(id);
                    //*
                    Navigation().closeDialog(context);
                    //*

                    Navigation().goToScreen(context, (context) => AllSessionsScreen());
                  },
                  child: const Icon(
                    Icons.info,
                    color: goSmartBlue,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xffFFDFBD),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: hasActiveSession ? Colors.green.shade100 : Colors.red.shade100,
                  ),
                  child: Text(
                    lastSessionUsername.isEmpty ? '' : lastSessionUsername[0],
                    textAlign: TextAlign.center,
                    style: mediumText.copyWith(color: Colors.green),
                  ),
                ),
                // const Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //         context: context,
                //         builder: (context) => EditPosSessionDialog(
                //               posName: name,
                //               posId: id,
                //             ));
                //   },
                //   child: Image.asset(
                //     'assets/images/edit.png',
                //     height: 25.h,
                //     width: 25.w,
                //   ),
                // ),
                // SizedBox(width: 10.w),
                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //         context: context,
                //         builder: (context) => DeletePosDialog(
                //               posName: name,
                //               posId: id,
                //             ));
                //   },
                //   child: Image.asset(
                //     'assets/images/bin.png',
                //     height: 25.h,
                //     width: 25.w,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'balance'.tr(),
                  style: mediumText,
                ),
                const Spacer(),
                Text(
                  '$lastSessionClosingCash ${'egp'.tr()}',
                  style: mediumText.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'closing_date'.tr(),
                  style: mediumText,
                ),
                const Spacer(),
                Text(
                  lastSessionClosingDate.isEmpty ? '' : DateFormat('dd/MM/yyyy').format(DateTime.parse(lastSessionClosingDate)),
                  style: mediumText.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'current_session'.tr(),
                  style: mediumText,
                ),
                const Spacer(),
                Text(
                  currentSession,
                  style: mediumText.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            const DottedLine(),
            const Spacer(),
            GestureDetector(
              onTap: () {
                print('sessionID $currentSessionId -- podID $id');
                if (hasActiveSession) {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => YesNoDialog(
                  //     dialogText: "${'there_is_active_session'.tr()}\n$currentSession",
                  //     onYesPressed: () async {
                  //       //*
                  //       Navigation().showLoadingGifDialog(context);

                  //       await context.read<PosProvider>().getCurrentSessionData(id);

                  //       //*
                  //       await PosApis().getClosingSessionData(currentSessionId).then((closingSessionData) {
                  //         //*
                  //         Navigation().closeDialog(context);
                  //         Navigation().closeDialog(context);
                  //         //*
                  //         showDialog(
                  //             context: context,
                  //             builder: (context) => CloseSessionDialog(
                  //                 isAdmin: true,
                  //                 //*
                  //                 sessionId: context.read<PosProvider>().currentSession.data![0].id!,
                  //                 posName: context.read<PosProvider>().currentSession.data![0].posName!,
                  //                 sessionName: context.read<PosProvider>().currentSession.data![0].name!,
                  //                 cashierName: context.read<PosProvider>().currentSession.data![0].cashierName!,
                  //                 openingCash: context.read<PosProvider>().currentSession.data![0].openingCash!,
                  //                 closingCash: 0.0,
                  //                 state: context.read<PosProvider>().currentSession.data![0].state!,
                  //                 startAt: context.read<PosProvider>().currentSession.data![0].startAt!.toString(),
                  //                 closeAt: DateTime.now().toString(),
                  //                 openingNote: context.read<PosProvider>().currentSession.data![0].openingNotes!,
                  //                 orderCount: context.read<PosProvider>().currentSession.data![0].ordersCount!,
                  //                 totalPaymentsAmount: context.read<PosProvider>().currentSession.data![0].totalPaymentsAmount!,
                  //                 closingNote: 'closingNote'));
                  //       });
                  //       //*
                  //     },
                  //     onNoPressed: () {
                  //       Navigation().closeDialog(context);
                  //     },
                  //   ),
                  // );
                  Navigation().goToScreen(context, (context) => HomeScreen(isAdmin: true));
                } else {
                  Navigation().goToScreen(context, (context) => HomeScreen(isAdmin: true));
                }
              },
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffFFC78A),
                      Color(0xfffff4e9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  hasActiveSession ? 'continue_session'.tr() : 'new_session'.tr(),
                  style: mediumText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
