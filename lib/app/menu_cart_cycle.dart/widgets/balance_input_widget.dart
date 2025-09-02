import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/main.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

class BalanceInputWidget extends StatefulWidget {
  const BalanceInputWidget({super.key});

  @override
  State<BalanceInputWidget> createState() => _BalanceInputWidgetState();
}

class _BalanceInputWidgetState extends State<BalanceInputWidget> {
  String _balance = '0.0';

  final noteController = TextEditingController();

  void _updateBalance(String value) {
    if (value == 'C') {
      //*
      _balance = '0.0';
      //*
    } else if (value == 'Submit') {
      //*
      //*
    } else {
      if (_balance == '0.0') {
        _balance = value;
      } else {
        if (_balance.contains('.') && value == '.') {
          //DO NOTHING
        } else {
          _balance += value;
        }
      }
    }
    //*
    //*
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posProviderRead = context.read<PosProvider>();

    return PopScope(
      canPop: false,
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: SizedBox(
          height: AppDimentions().availableheightWithAppBar * 0.9,
          width: AppDimentions().availableWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "add_opening_cash".tr(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: goSmartBlue,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: 200.w,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: goSmartBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  _balance,
                  style: TextStyle(
                    fontSize: 27.sp,
                    fontWeight: FontWeight.w600,
                    color: black,
                  ),
                ),
              ),
              //*
              SizedBox(height: 20.h),

              //*
              Text(
                "notes".tr(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.bold,
                  color: goSmartBlue,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: goSmartBlue.withOpacity(0.1),
                ),
                child: TextField(
                  controller: noteController,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),

              //*
              SizedBox(height: 20.h),
              _buildNumberPad(),
              // SizedBox(height: 20.h),
              const Spacer(),
              BlueButton(
                  label: 'submit'.tr(),
                  onPressed: () async {
                    print('BALANCE: $_balance');
                    print('NOTE: ${noteController.text}');

                    Navigation().showLoadingGifDialog(context);
                    //*
                    await context.read<PosProvider>().openNewPosSession(
                        posId, posProviderRead.loginData.userId!, currencyId, double.parse(_balance), noteController.text);
                    //*
                    Navigation().closeDialog(context);
                    //*
                    Navigation().closeDialog(context);
                  }),
              //  _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    List<String> keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'C',
      '0',
      '.',
    ];

    return SizedBox(
      width: 250.w,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.4.w,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: keys.length,
        itemBuilder: (context, index) {
          return _buildButton(keys[index]);
        },
      ),
    );
  }

  Widget _buildButton(String value) {
    return ElevatedButton(
      onPressed: () => _updateBalance(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 22, color: black),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlueButton(
      onPressed: () => _updateBalance('Submit'),
      // style: ElevatedButton.styleFrom(
      //   backgroundColor: Colors.grey[100],
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      // ),
      label:
          // Text(
          'submit'.tr(),
      // style: const TextStyle(fontSize: 20, color: black),
      //  ),
    );
  }
}
