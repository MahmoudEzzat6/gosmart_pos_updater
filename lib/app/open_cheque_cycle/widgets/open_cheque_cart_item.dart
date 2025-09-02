import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/customize_product_dialog.dart';
import 'package:pos_windows_ice_hub/helpers/localized_helper.dart';
import 'package:provider/provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';

class OpenChequeCartItem extends StatelessWidget {
  final int id;
  final String name;
  final String nameAr;
  final String size;
  final String image;
  final List<int> taxId;
  final List<Extras> extras;
  final double totalPrice;
  final int quantity;
  final double? discount;
  final bool isExtra;
  final String notes;
  final String description;
  final String descriptionAr;
  final double qtyAvailable;
  // final double virtualAvailable;
  //*
  final bool isInCheckout;

  final int selectedSizeIndexEdit;
  final List<Extras> selectedExtrasEdit;
  final List<double> extraPriceListEdit;
  final int numOfProductsEdit;
  final String customerNote;
  final String orderTimeStamp;
  //* //*
  final bool isDiscount;

  const OpenChequeCartItem({
    super.key,
    required this.id,
    required this.name,
    required this.size,
    required this.extras,
    required this.totalPrice,
    required this.quantity,
    this.discount,
    required this.isExtra,
    required this.notes,
    required this.isInCheckout,
    required this.image,
    required this.taxId,
    required this.description,
    required this.descriptionAr,
    //* //*
    required this.selectedSizeIndexEdit,
    required this.selectedExtrasEdit,
    required this.extraPriceListEdit,
    required this.numOfProductsEdit,
    required this.customerNote,
    required this.orderTimeStamp,
    required this.qtyAvailable,
    required this.nameAr,
    //* //*
    required this.isDiscount,
    //required this.virtualAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !isExtra
          ? Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 1,
              child:
                  //* NORMAL ITEM
                  Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title, Edit Icon, and Delete Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            // context.locale == const Locale('ar')
                            //     ? nameAr.isEmpty
                            //         ? name
                            //         : nameAr
                            //     : name,
                            context.localizedValue(en: name, ar: nameAr),
                            style: boldText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        //TODO NO DELETE OR EDIT FOR KARIMA & YOUSEF
                        // if (isInCheckout == false) ...[
                        //   if (isDiscount == false)
                        //     IconButton(
                        //       icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                        //       onPressed: () {
                        //         print(name);
                        //         showDialog(
                        //             barrierDismissible: false,
                        //             context: context,
                        //             builder: (context) => CustomizeProductDialog(
                        //                   isEdit: true,
                        //                   key: ValueKey(id),
                        //                   productId: id,
                        //                   isOthers: name.toLowerCase() == 'others' || name.toLowerCase() == 'اخرى',
                        //                   name: name,
                        //                   nameAr: nameAr,
                        //                   image: image,
                        //                   //  price: menuProviderWatch.selectedProductsList.data![index].listPrice!,
                        //                   taxesId: taxId,
                        //                   description: description,
                        //                   descriptionAr: descriptionAr,
                        //                   quantityAvailable: qtyAvailable,
                        //                   //* //*
                        //                   extraPriceListEdit: extraPriceListEdit,
                        //                   numOfProductsEdit: numOfProductsEdit,
                        //                   selectedExtrasEdit: selectedExtrasEdit,
                        //                   selectedSizeIndexEdit: selectedSizeIndexEdit,
                        //                   customerNote: customerNote,
                        //                   orderTimeStampEdit: orderTimeStamp,
                        //                   //* //*
                        //                 ));
                        //       },
                        //     ),

                        //   if (isDiscount == false)
                        //     IconButton(
                        //       icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        //       onPressed: () {
                        //         //Delete the item from the cart
                        //         context.read<MenuProvider>().removeFromCart(orderTimeStamp);
                        //       },
                        //     ),
                        // ]
                      ],
                    ),

                    // Size, Quantity, and Price
                    Row(
                      children: [
                        Text("${'size'.tr()}: ", style: mediumText),
                        Text(size, style: mediumText.copyWith(color: goSmartBlue)),
                        SizedBox(width: 10.w),
                        Text("${'units'.tr()}: ", style: mediumText),
                        Text(quantity.toString(), style: mediumText.copyWith(color: goSmartBlue)),
                        const Spacer(),
                        Text(
                          "${totalPrice.toStringAsFixed(2)} ${'egp'.tr()}",
                          style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w600, color: goSmartBlue),
                        ),
                      ],
                    ),

                    if (notes.isNotEmpty) ...[
                      Text("${'notes'.tr()}: ", style: mediumText),
                      Text(
                        notes,
                        maxLines: 2,
                      ),
                    ],

                    // Extras Section
                    if (extras.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 5.h),
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: goSmartBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long, size: 16, color: goSmartBlue),
                            SizedBox(width: 5.w),
                            Text("extra".tr(), style: mediumText.copyWith(color: goSmartBlue)),
                          ],
                        ),
                      ),

                    // Discount Section
                    if (discount != null && discount! > 0)
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
                              "-${discount!.toStringAsFixed(2)} ${'egp'.tr()} (${(discount! / totalPrice * 100).round()}% ${'discount'.tr()})",
                              style: mediumText.copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )
          :
          //* IS EXTRA
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              //    margin: EdgeInsets.symmetric(vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title, Edit Icon, and Delete Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          context.locale == const Locale('ar') ? nameAr : name,
                          style: mediumText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${totalPrice.toStringAsFixed(2)} ${'egp'.tr()}",
                        style: GoogleFonts.roboto(fontSize: 18.sp, fontWeight: FontWeight.w500, color: goSmartBlue),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text("${'units'.tr()}: ", style: smallText),
                      Text(quantity.toString(), style: mediumText.copyWith(color: goSmartBlue)),
                    ],
                  ),

                  // Extras Section
                  if (extras.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: goSmartBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt_long, size: 16, color: goSmartBlue),
                          SizedBox(width: 5.w),
                          Text("extra".tr(), style: mediumText.copyWith(color: goSmartBlue)),
                        ],
                      ),
                    ),

                  // Discount Section
                  if (discount != null && discount! > 0)
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
                            "-${discount!.toStringAsFixed(2)} ${'egp'.tr()} (${(discount! / totalPrice * 100).round()}% ${'discount'.tr()})",
                            style: mediumText.copyWith(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
