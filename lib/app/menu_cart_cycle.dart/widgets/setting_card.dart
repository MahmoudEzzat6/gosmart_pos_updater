  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';

Widget buildSettingCard(BuildContext context,
      {required IconData icon, required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      elevation: 1.5,
      child: Padding(
        padding: EdgeInsets.all(20.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 28.sp, color: goSmartBlue),
                SizedBox(width: 15.w),
                Text(
                  title,
                  style: mediumText.copyWith(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
