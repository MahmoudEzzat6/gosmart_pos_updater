import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:provider/provider.dart';

class ChangeTableNameDialog extends StatefulWidget {
  const ChangeTableNameDialog({super.key});

  @override
  State<ChangeTableNameDialog> createState() => _ChangeTableNameDialogState();
}

class _ChangeTableNameDialogState extends State<ChangeTableNameDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.4,
        child: Text(
          'تغيير اسم الطاولة',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(color: goSmartBlue, fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      content: TextField(
        textDirection: TextDirection.rtl,
        controller: _controller,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          hintText: "اسم الطاوله",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("cancel".tr()),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (_controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("please_enter_table_name".tr())),
              );
              return;
            }
            context.read<OpenChequeProvider>().changeTableName(
                  context.read<OpenChequeProvider>().selectedTableId,
                  _controller.text,
                );
            Navigator.of(context).pop();
          },
          child: Text("save".tr()),
        ),
      ],
    );
  }
}
