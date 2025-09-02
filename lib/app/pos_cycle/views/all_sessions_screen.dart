import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/refund_request_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/session_details_dialog.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

import '../../../styles/colors.dart';

class AllSessionsScreen extends StatelessWidget {
  AllSessionsScreen({super.key});

  final searchController = TextEditingController();
  final searchNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final posProviderRead = context.read<PosProvider>();

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SizedBox(
          height: AppDimentions().availableheightWithAppBar,
          width: AppDimentions().availableWidth,
          child: Column(
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
                    SizedBox(width: 30.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: Colors.grey[500]),
                      // child: Image.asset(
                      //   'assets/images/grid.png',
                      //   color: Colors.grey[500],
                      //   height: 25.h,
                      //   width: 25.w,
                      // ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            posProviderRead.loginData.name!,
                            style: mediumText.copyWith(
                              color: Colors.grey[400],
                              fontSize: 17.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'admin'.tr(),
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
                          onChanged: posProviderRead.onSearchAllSessionsTextChanged,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'search'.tr(),
                            hintStyle: mediumText.copyWith(color: const Color(0xffA6B3BA).withOpacity(0.5), fontSize: 17.sp),
                            // border: textBorder,
                            // errorBorder: textBorder,
                            // enabledBorder: textBorder,
                            // focusedBorder: textBorder,
                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Image.asset(
                                'assets/images/search.png',
                                height: 15,
                                width: 15,
                                color: goSmartBlue,
                              ),
                            ),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  posProviderRead.clearSearchAllSessionsList();
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
                    Image.asset(
                      'assets/images/pos.png',
                      height: 25.h,
                      width: 25.w,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'sessions'.tr(),
                            style: boldText.copyWith(fontSize: 18.sp),
                          ),
                          const Spacer(),
                          // Text('filter_by'.tr()),
                          BlueButton(
                              label: 'refund_request'.tr(),
                              onPressed: () {
                                showDialog(context: context, builder: (context) => const RefundRequestDialog());
                              }),
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
                                  'session'.tr(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'pos'.tr(),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'cashier'.tr(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'status'.tr(),
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
                      //* //* IS SEARCHING DATA
                      if (posProviderRead.isSearchingSessions)
                        Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: posProviderRead.allSessionsSearchResult.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SessionDetailsDialog(
                                              key: ValueKey(posProviderRead.allSessionsSearchResult[index].id),
                                              posName: posProviderRead.allSessionsSearchResult[index].posName!,
                                              cashierName: posProviderRead.allSessionsSearchResult[index].cashierName!,
                                              sessionName: posProviderRead.allSessionsSearchResult[index].name!,
                                              startAt: posProviderRead.allSessionsSearchResult[index].startAt!,
                                              closeAt: posProviderRead.allSessionsSearchResult[index].stopAt!,
                                              closingCash: posProviderRead.allSessionsSearchResult[index].closingCash!,
                                              openingCash: posProviderRead.allSessionsSearchResult[index].openingCash!,
                                              openingNote: posProviderRead.allSessionsSearchResult[index].openingNotes!,
                                              closingNote: posProviderRead.allSessionsSearchResult[index].closingNotes!,
                                              orderCount: posProviderRead.allSessionsSearchResult[index].ordersCount!,
                                              sessionId: posProviderRead.allSessionsSearchResult[index].id!,
                                              state: posProviderRead.allSessionsSearchResult[index].state!,
                                              totalPaymentsAmount:
                                                  posProviderRead.allSessionsSearchResult[index].totalPaymentsAmount!,
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
                                        child: Text(
                                          posProviderRead.allSessionsSearchResult[index].name!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          posProviderRead.allSessionsSearchResult[index].posName!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          posProviderRead.allSessionsSearchResult[index].cashierName!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 7.h,
                                              width: 7.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: posProviderRead.allSessionsSearchResult[index].state!.toLowerCase() ==
                                                        'closed'
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              posProviderRead.allSessionsSearchResult[index].state!,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      else
                        Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) => const Divider(),
                              itemCount: posProviderRead.posSessions.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SessionDetailsDialog(
                                              key: ValueKey(posProviderRead.posSessions.data![index].id),
                                              posName: posProviderRead.posSessions.data![index].posName!,
                                              cashierName: posProviderRead.posSessions.data![index].cashierName!,
                                              sessionName: posProviderRead.posSessions.data![index].name!,
                                              startAt: posProviderRead.posSessions.data![index].startAt!,
                                              closeAt: posProviderRead.posSessions.data![index].stopAt!,
                                              closingCash: posProviderRead.posSessions.data![index].closingCash!,
                                              openingCash: posProviderRead.posSessions.data![index].openingCash!,
                                              openingNote: posProviderRead.posSessions.data![index].openingNotes!,
                                              closingNote: posProviderRead.posSessions.data![index].closingNotes!,
                                              orderCount: posProviderRead.posSessions.data![index].ordersCount!,
                                              sessionId: posProviderRead.posSessions.data![index].id!,
                                              state: posProviderRead.posSessions.data![index].state!,
                                              totalPaymentsAmount: posProviderRead.posSessions.data![index].totalPaymentsAmount!,
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
                                        child: Text(
                                          posProviderRead.posSessions.data![index].name!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          posProviderRead.posSessions.data![index].posName!,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          posProviderRead.posSessions.data![index].cashierName!,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 7.h,
                                              width: 7.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: posProviderRead.posSessions.data![index].state!.toLowerCase() == 'closed'
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              posProviderRead.posSessions.data![index].state!,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
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
    );
  }
}
