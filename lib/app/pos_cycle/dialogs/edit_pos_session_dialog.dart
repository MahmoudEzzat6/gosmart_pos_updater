import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class EditPosSessionDialog extends StatefulWidget {
  final String posName;
  final int posId;

  const EditPosSessionDialog({super.key, required this.posName, required this.posId});

  @override
  State<EditPosSessionDialog> createState() => _EditPosSessionDialogState();
}

class _EditPosSessionDialogState extends State<EditPosSessionDialog> {
  TextEditingController posNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    posNameController.text = widget.posName;
  }

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);
    return AlertDialog(
      content: SizedBox(
        //   height: 300,
        width: AppDimentions().availableWidth * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'edit_pos'.tr(),
              style: boldText.copyWith(
                fontSize: 18.sp,
              ),
            ),
            const Divider(
              color: black,
            ),
            SizedBox(height: 20.h),
            Text(
              'pos_name'.tr(),
              style: mediumText,
            ),
            SizedBox(height: 20.h),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: TextField(
                controller: posNameController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: '${'edit_pos'.tr()}...',
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: 40.h,
                    width: 100.w,
                    child: BlueButton(
                        label: 'save'.tr(),
                        onPressed: () async {
                          // showDialog(
                          //     context: context,
                          //     builder: (context) => const Center(
                          //           child: LoadingIndicator(
                          //             indicatorType: Indicator.ballClipRotateMultiple,
                          //             strokeWidth: 5,
                          //             colors: [goSmartBlue],
                          //           ),
                          //         ));
                          //* //*/ //* //*
                          if (posNameController.text.isNotEmpty) {
                            Navigation().showLoadingGifDialog(context);
                            //*
                            await PosApis().editPosName(posNameController.text, widget.posId).then((statusMsg) async {
                              //*
                              await context.read<PosProvider>().getAllPos();
                              //*
                              Navigation().closeDialog(context);
                              Navigation().closeDialog(context);
                            });
                          }
                        })),
                SizedBox(width: 30.w),
                SizedBox(
                    height: 40.h,
                    width: 100.w,
                    child: GreyButton(
                        label: 'cancel'.tr(),
                        onPressed: () {
                          Navigation().closeDialog(context);
                        })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
