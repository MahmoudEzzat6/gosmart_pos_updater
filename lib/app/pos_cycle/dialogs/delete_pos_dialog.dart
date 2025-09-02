import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/unclosable_ok_dialog.dart';
import 'package:provider/provider.dart';

class DeletePosDialog extends StatelessWidget {
  final String posName;
  final int posId;

  const DeletePosDialog({super.key, required this.posName, required this.posId});

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);
    return AlertDialog(
      content: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/bin_bg.png',
              height: 70.h,
              width: 70.w,
            ),
            SizedBox(height: 20.h),
            Text(
              'delete_pos'.tr(),
              style: mediumText.copyWith(fontSize: 18.sp),
            ),
            Text(
              '${'delete_pos_message'.tr()} "$posName"',
              textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              style: smallText.copyWith(
                color: textGrey,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    height: 35.h,
                    width: 100.w,
                    child: GreyButton(
                        label: 'back'.tr(),
                        onPressed: () {
                          Navigation().closeDialog(context);
                        })),
                SizedBox(
                    height: 35.h,
                    width: 100.w,
                    child: CancelButton(
                        label: 'delete'.tr(),
                        onPressed: () async {
                          print('DELETE >> $posId');
                          Navigation().showLoadingGifDialog(context);
                          //*
                          var statusMsg = await context.read<PosProvider>().archivePos(posId);
                          //*
                          Navigation().closeDialog(context);
                          //*
                          showDialog(
                              context: context,
                              builder: (context) => UnClosableOkDialog(
                                    text: statusMsg!.messageAr!,
                                    onPressed: () {
                                      Navigation().closeDialog(context);
                                      Navigation().closeDialog(context);
                                    },
                                  ));
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
