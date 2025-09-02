import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';

class OkDialog extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const OkDialog({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(color: goSmartBlue, fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: 150.w,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(goSmartBlue),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  onPressed: onPressed,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text('ok'.tr(),
                        textAlign: TextAlign.center,
                        textDirection: context.locale == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
                        style: const TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
