import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_users.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

class SetDeliveryDialog extends StatefulWidget {
  const SetDeliveryDialog({super.key});

  @override
  State<SetDeliveryDialog> createState() => _SetDeliveryDialogState();
}

class _SetDeliveryDialogState extends State<SetDeliveryDialog> {
  final TextEditingController phoneController = TextEditingController();
  final phoneNUmberNode = FocusNode();

  bool userFound = false;
  bool isSearching = true;

  late DeliveryUsers deliveryUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final userPhoneController = TextEditingController();
  final userAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: (!userFound && isSearching)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ادخل رقم الهاتف'),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 50.h,
                    child: TextField(
                      controller: phoneController,
                      focusNode: phoneNUmberNode,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'رقم الهاتف',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        errorBorder: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  BlueButton(
                      label: 'search'.tr(),
                      onPressed: () async {
                        if (phoneController.text.isNotEmpty) {
                          Navigation().showLoadingGifDialog(context);
                          //*
                          phoneNUmberNode.unfocus();
                          //*
                          //   await PosApis().getDeliveryUserByNumber(phoneController.text).then((value) {
                          await context.read<PosProvider>().getDeliveryUsers(phoneController.text).then((value) {
                            Navigation().closeDialog(context);

                            deliveryUser = context.read<PosProvider>().deliveryUsers;

                            if (deliveryUser.status == 1) {
                              //* USER EXISTS

                              userFound = true;
                              isSearching = false;

                              setState(() {});
                            } else {
                              userFound = false;
                              isSearching = false;

                              userPhoneController.text = phoneController.text;

                              setState(() {});
                            }
                          });
                        }
                      })
                ],
              )
            : (userFound && isSearching == false)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'تم العثور على العميل',
                        textAlign: TextAlign.center,
                      ),
                      const Divider(),
                      Text(deliveryUser.data![0].name!),
                      Text(deliveryUser.data![0].phone!),
                      Text(deliveryUser.data![0].address!),
                      SizedBox(height: 20.h),
                      BlueButton(
                          label: 'ok'.tr(),
                          onPressed: () {
                            context.read<PosProvider>().setIsDeliveryOrder = true;

                            Navigation().closeDialog(context);
                          })
                    ],
                  )
                : Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'لم يتم العثور على العميل',
                            textAlign: TextAlign.center,
                          ),
                          const Divider(),
                          SizedBox(height: 10.h),
                          Text(
                            'تسجيل عميل جديد',
                            style: smallText.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextFormField(
                            controller: userNameController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الاسم مطلوب';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'الاسم',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: userPhoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'رقم الهاتف مطلوب';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: 'رقم الهاتف',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: userAddressController,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'العنوان مطلوب';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'العنوان',
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          BlueButton(
                              label: 'register_new_user'.tr(),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigation().showLoadingGifDialog(context);

                                  await context.read<PosProvider>().addNewDeliveryUser(
                                      userNameController.text, userPhoneController.text, userAddressController.text);

                                  Navigation().closeDialog(context);
                                  Navigation().closeDialog(context);
                                }
                              })
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
