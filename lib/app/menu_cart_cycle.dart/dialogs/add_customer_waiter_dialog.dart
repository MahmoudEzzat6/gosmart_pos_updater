import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

class AddCustomerWaiterDialog extends StatefulWidget {
  const AddCustomerWaiterDialog({super.key});

  @override
  State<AddCustomerWaiterDialog> createState() => _AddCustomerWaiterDialogState();
}

class _AddCustomerWaiterDialogState extends State<AddCustomerWaiterDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _waiterNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: AppDimentions().availableWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اضافة عميل',
                    style: boldText,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        textDirection: TextDirection.rtl,
                        controller: _customerNameController,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey[150],
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            label: Text(
                              'اسم ',
                              style: smallText,
                            ),
                            alignLabelWithHint: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل اسم العميل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _customerPhoneController,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey[150],
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            labelText: 'رقم الهاتف'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك ادخل رقم العميل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _waiterNameController,
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey[150],
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            errorBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none),
                            labelText: 'اسم النادل'),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'من فضلك ادخل اسم النادل';
                        //   }
                        //   return null;
                        // },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                          height: 40.h,
                          child: BlueButton(
                              label: 'submit'.tr(),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Handle the submission logic here
                                  final customerName = _customerNameController.text;
                                  final customerPhone = _customerPhoneController.text;
                                  final waiterName = _waiterNameController.text;

                                  // You can use these values to update your state or send them to an API
                                  print('Customer Name: $customerName');
                                  print('Customer Phone: $customerPhone');
                                  print('Waiter Name: $waiterName');

                                  Map<String, dynamic> customerData = {
                                    'customerName': customerName,
                                    'customerPhone': customerPhone,
                                    'waiterName': waiterName,
                                  };

                                  context.read<MenuProvider>().setCustomerData = customerData;

                                  Navigator.of(context).pop();
                                }
                              })),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
