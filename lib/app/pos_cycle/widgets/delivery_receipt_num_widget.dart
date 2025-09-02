import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryReceiptNumWidget extends StatefulWidget {
  const DeliveryReceiptNumWidget({super.key});

  @override
  State<DeliveryReceiptNumWidget> createState() =>
      _DeliveryReceiptNumWidgetState();
}

class _DeliveryReceiptNumWidgetState extends State<DeliveryReceiptNumWidget> {
  int? selectedNumber;

  @override
  void initState() {
    super.initState();
    _loadSavedNumber();
  }

  Future<void> _loadSavedNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedNumber = prefs.getInt('receipt_number');
    });
  }

  // Save value
  Future<void> _saveNumber(int number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('receipt_number', number);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedNumber,
      hint: Text(
        "select_number",
        style: TextStyle(fontSize: 22.sp, color: Colors.black),
      ).tr(),
      items: List.generate(
        3,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text((index + 1).toString()),
        ),
      ),
      onChanged: (number) {
        if (number != null) {
          setState(() {
            selectedNumber = number;
          });
          _saveNumber(number);
        }
      },
    );
  }
}
