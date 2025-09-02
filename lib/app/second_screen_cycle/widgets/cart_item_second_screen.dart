import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/customize_product_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';

class CartItemSecondScreen extends StatelessWidget {
  final int id;
  final String name;
  final String nameAr;
  final String size;
  final bool hasExtras;
  final double totalPrice;
  final int quantity;
  final double discount;
  // final bool isExtra;
  final String notes;
  final String description;
  final String descriptionAr;
  final String image;
  final String orderTimeStamp;
  final dynamic extraList;

  const CartItemSecondScreen({
    super.key,
    required this.id,
    required this.name,
    required this.size,
    required this.hasExtras,
    required this.totalPrice,
    required this.quantity,
    required this.discount,
    //  required this.isExtra,
    required this.notes,
    required this.description,
    required this.descriptionAr,
    required this.nameAr,
    required this.image,
    required this.orderTimeStamp,
    required this.extraList,
  });

  @override
  Widget build(BuildContext context) {
    // List<dynamic> dataList = json.decode(extraList);

    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: goSmartBlue,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Title, Edit Icon, and Delete Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.network(
                      image,
                      height: 40.h,
                      width: 40.w,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        context.locale == const Locale('ar')
                            ? nameAr.isEmpty
                                ? name
                                : nameAr
                            : name,
                        style: receiptmediumText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Size, Quantity, and Price
                Row(
                  children: [
                    Text("${'size'.tr()}: ", style: receiptmediumText),
                    Text(size, style: receiptmediumText.copyWith(color: goSmartBlue)),
                    SizedBox(width: 10.w),
                    Text("${'units'.tr()}: ", style: receiptmediumText),
                    Text(quantity.toString(), style: receiptmediumText.copyWith(color: goSmartBlue)),
                    const Spacer(),
                    Text(
                      "${totalPrice.toStringAsFixed(2)} ${'egp'.tr()}",
                      style: receiptmediumText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600, color: goSmartBlue),
                    ),
                  ],
                ),

                if (notes.isNotEmpty) ...[
                  Text("${'notes'.tr()}: ", style: receiptmediumText),
                  Text(
                    notes,
                    maxLines: 2,
                  ),
                ],

                // Extras Section

                // Discount Section
                if (discount > 0)
                  Container(
                    margin: EdgeInsets.only(top: 5.h),
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer, size: 16, color: Colors.green),
                        SizedBox(width: 5.w),
                        Text(
                          "-${discount.toStringAsFixed(2)} ${'egp'.tr()} (${(discount / totalPrice * 100).round()}% ${'discount'.tr()})",
                          style: receiptmediumText.copyWith(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                //* //* //*
              ],
            ),
          ),
          Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasExtras)
                      Container(
                        margin: EdgeInsets.only(top: 5.h),
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: goSmartBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.receipt_long, size: 16, color: goSmartBlue),
                                SizedBox(width: 5.w),
                                Text("extra".tr(), style: receiptmediumText.copyWith(color: goSmartBlue)),
                              ],
                            ),
                            //*
                          ],
                        ),
                      ),
                    if (extraList.isNotEmpty)
                      ...List.generate(extraList.length, (index) {
                        Map<String, dynamic> dataMap = json.decode(extraList[index]);

                        //   return Text('${dataMap['product_name']} -- ${dataMap['quantity']} -- ${dataMap['price']}');

                        return Row(
                          children: [
                            SizedBox(width: 10.w),
                            Expanded(flex: 5, child: Text("${dataMap['product_name']} ", style: receiptmediumText)),
                            SizedBox(width: 10.w),
                            Expanded(flex: 1, child: Text("${'units'.tr()}: ", style: receiptmediumText)),
                            Expanded(
                              flex: 1,
                              child: Text(dataMap['quantity'].toStringAsFixed(0),
                                  style: receiptmediumText.copyWith(color: goSmartBlue)),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "${(dataMap['price'] * dataMap['quantity']).toStringAsFixed(2)} ${'egp'.tr()}",
                                textAlign: TextAlign.end,
                                style:
                                    receiptmediumText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600, color: goSmartBlue),
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        );
                      }),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
