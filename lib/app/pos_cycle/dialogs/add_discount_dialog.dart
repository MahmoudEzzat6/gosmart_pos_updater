import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:provider/provider.dart';

class AddDiscountDialog extends StatefulWidget {
  const AddDiscountDialog({super.key});

  @override
  State<AddDiscountDialog> createState() => _AddDiscountDialogState();
}

class _AddDiscountDialogState extends State<AddDiscountDialog> {
  bool isCashDiscount = true;

  final discountController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    final menuProviderWatch = context.watch<MenuProvider>();
    final menuProviderRead = context.read<MenuProvider>();

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      content: Form(
        key: formKey,
        child: Directionality(
          textDirection: context.locale == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
          child: SizedBox(
            width: AppDimentions().availableWidth * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCashDiscount = true;
                        });
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: goSmartBlue),
                        child: isCashDiscount
                            ? Center(
                                child: Image.asset(
                                'assets/images/check-mark.png',
                                height: 27.h,
                                width: 27.w,
                                color: white,
                              ))
                            : Container(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'cash_discount'.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCashDiscount = false;
                        });
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: goSmartBlue),
                        child: !isCashDiscount
                            ? Center(child: Image.asset('assets/images/check-mark.png', color: white, height: 27.h, width: 27.w))
                            : Container(),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'percentage_discount'.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: discountController,
                  textAlign: TextAlign.right,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp("[-]")),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'discount_amount_required'.tr();
                    }
                    final double? amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'invalid_discount_amount'.tr();
                    }
                    if (amount > context.read<MenuProvider>().cartTotal && isCashDiscount) {
                      return 'discount_amount_exceeds_cart_total'.tr();
                    }
                    if (amount > 100 && isCashDiscount == false) {
                      return 'discount_amount_exceeds_cart_total'.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text(
                      'discount_amount'.tr(),
                    ),
                    border: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
                    //*
                    suffixIcon: Icon(
                      isCashDiscount ? Icons.money : Icons.percent,
                      color: black,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150.w,
                      height: 40.h,
                      child: GreyButton(
                          label: 'cancel'.tr(),
                          onPressed: () {
                            Navigation().closeDialog(context);
                          }),
                    ),
                    SizedBox(
                        width: 150.w,
                        height: 40.h,
                        child: BlueButton(
                            label: 'add_discount'.tr(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (isCashDiscount) {
                                  menuProviderRead.setDiscount(double.parse(discountController.text));

                                  menuProviderRead.addToCart(CartLineItem(
                                    quantity: 1,
                                    priceUnit: menuProviderRead.discount * -1,
                                    priceSubtotalWithoutTax: menuProviderRead.discount * -1,
                                    priceWithTax: menuProviderRead.discount * -1,
                                    taxesName: '',
                                    discount: 0,
                                    productId: menuProviderRead.discountModel.data![0].id!,
                                    taxIds: [],
                                    productName: 'Discount',
                                    kitchenNote: '',
                                    priceType: 'automatic',
                                    customerNote: '',
                                    //* //*
                                    extraPriceList: [],
                                    description: '',
                                    descriptionAr: '',
                                    image: '',
                                    qtyAvailable: 0,
                                    selectedSize: '',
                                    extras: [],
                                    extrasString: '',
                                    isExtra: false,
                                    numOfProductsEdit: 0,
                                    orderTimeStamp: '',
                                    selectedExtrasEdit: [],
                                    selectedSizeIndexEdit: 0,
                                  ));
                                } else {
                                  menuProviderRead
                                      .setDiscount(menuProviderRead.cartTotal * (double.parse(discountController.text) / 100));

                                  menuProviderRead.addToCart(CartLineItem(
                                    quantity: 1,
                                    priceUnit: menuProviderRead.discount * -1,
                                    priceSubtotalWithoutTax: menuProviderRead.discount * -1,
                                    priceWithTax: menuProviderRead.discount * -1,
                                    discount: 0,
                                    taxesName: '',
                                    productId: menuProviderRead.discountModel.data![0].id!,
                                    taxIds: [],
                                    productName: 'Discount',
                                    kitchenNote: '',
                                    priceType: 'automatic',
                                    customerNote: '',
                                    //* //*
                                    extraPriceList: [],
                                    description: '',
                                    descriptionAr: '',
                                    image: '',
                                    qtyAvailable: 0,
                                    selectedSize: '',
                                    extras: [],
                                    extrasString: '',
                                    isExtra: false,
                                    numOfProductsEdit: 0,
                                    orderTimeStamp: '',
                                    selectedExtrasEdit: [],
                                    selectedSizeIndexEdit: 0,
                                  ));
                                }
                                //* //*
                                context.read<PosProvider>().setDiscountApplied = true;
                                context.read<PosProvider>().setPromotionApplied = false;
                                //* //*
                                Navigation().closeDialog(context);
                              }
                            })),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
