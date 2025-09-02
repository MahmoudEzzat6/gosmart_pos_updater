import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/change_language_widget.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/setting_card.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/settings/resize_screen.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/widgets/delivery_receipt_num_widget.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/usb_printer_setup_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PosSettingsScreen extends StatefulWidget {
  const PosSettingsScreen({super.key});

  @override
  State<PosSettingsScreen> createState() => _PosSettingsScreenState();
}

class _PosSettingsScreenState extends State<PosSettingsScreen> {
  Size? savedSize;
  @override
  void initState() {
    super.initState();
    loadSavedSize();
  }

  Future<void> loadSavedSize() async {
    final pref = await SharedPreferences.getInstance();
    final double? width = pref.getDouble('screenWidth');
    final double? height = pref.getDouble('screenHeight');

    if (width != null && height != null) {
      setState(() {
        savedSize = Size(width, height);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28.sp, color: goSmartBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.all(30.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  'settings'.tr(),
                  style: mediumText.copyWith(
                    fontSize: 42.sp,
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Settings cards in a column
              Expanded(
                child: ListView(
                  children: [
                    buildSettingCard(
                      context,
                      icon: Icons.print,
                      title: "choose_printer".tr(),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(250.w, 50.h),
                          backgroundColor: goSmartBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: SizedBox(
                                height:
                                    AppDimentions().availableheightNoAppBar *
                                        0.8,
                                width: AppDimentions().availableWidth * 0.8,
                                child: const USBPrinterSetupWidget(
                                    isFromSettings: true),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'choose_printer'.tr(),
                          style: mediumText.copyWith(
                            fontSize: 18.sp,
                            color: white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    buildSettingCard(
                      context,
                      icon: Icons.language,
                      title: "language".tr(),
                      child: const LanguageDropdownWidget(),
                    ),
                    SizedBox(height: 20.h),
                    buildSettingCard(
                      context,
                      icon: Icons.receipt,
                      title: "receipt_copies".tr(),
                      child: const DeliveryReceiptNumWidget(),
                    ),

                    //*Resize At Drawewr
                    // SizedBox(height: 20.h),
                    // buildSettingCard(
                    //   context,
                    //   icon: Icons.settings,
                    //   title: "screen_resize".tr(),
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       minimumSize: Size(250.w, 50.h),
                    //       backgroundColor: goSmartBlue,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.r),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       Navigation().goToScreen(
                    //           context, (context) => const ResizeScreen());
                    //     },
                    //     child: Text(
                    //       savedSize != null
                    //           ? '${savedSize!.width.toInt()}x ${savedSize!.height.toInt()}'
                    //           : ' N/A',
                    //       style: mediumText.copyWith(
                    //         fontSize: 18.sp,
                    //         color: white,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
