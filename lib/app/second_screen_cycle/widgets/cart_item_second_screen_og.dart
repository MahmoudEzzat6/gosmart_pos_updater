// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/customize_product_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
// import 'package:pos_windows_ice_hub/styles/colors.dart';
// import 'package:pos_windows_ice_hub/styles/text_style.dart';

// class CartItemSecondScreen extends StatelessWidget {
//   final int id;
//   final String name;
//   final String nameAr;
//   final String size;
//   final bool hasExtras;
//   final double totalPrice;
//   final int quantity;
//   final double discount;
//   final bool isExtra;
//   final String notes;
//   final String description;
//   final String descriptionAr;
//   final String image;
//   final String orderTimeStamp;

//   const CartItemSecondScreen({
//     super.key,
//     required this.id,
//     required this.name,
//     required this.size,
//     required this.hasExtras,
//     required this.totalPrice,
//     required this.quantity,
//     required this.discount,
//     required this.isExtra,
//     required this.notes,
//     required this.description,
//     required this.descriptionAr,
//     required this.nameAr,
//     required this.image,
//     required this.orderTimeStamp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: !isExtra
//           ? Container(
//               padding: const EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 5.h),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.r),
//                   border: Border.all(
//                     color: goSmartBlue,
//                   )),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Product Title, Edit Icon, and Delete Icon
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Image.network(
//                               image,
//                               height: 40.h,
//                               width: 40.w,
//                             ),
//                             SizedBox(width: 10.w),
//                             Expanded(
//                               child: Text(
//                                 context.locale == const Locale('ar')
//                                     ? nameAr.isEmpty
//                                         ? name
//                                         : nameAr
//                                     : name,
//                                 style: receiptmediumText,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),

//                         // Size, Quantity, and Price
//                         Row(
//                           children: [
//                             Text("${'size'.tr()}: ", style: receiptmediumText),
//                             Text(size, style: receiptmediumText.copyWith(color: goSmartBlue)),
//                             SizedBox(width: 10.w),
//                             Text("${'units'.tr()}: ", style: receiptmediumText),
//                             Text(quantity.toString(), style: receiptmediumText.copyWith(color: goSmartBlue)),
//                             const Spacer(),
//                             Text(
//                               "${totalPrice.toStringAsFixed(2)} ${'egp'.tr()}",
//                               style: receiptmediumText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600, color: goSmartBlue),
//                             ),
//                           ],
//                         ),

//                         if (notes.isNotEmpty) ...[
//                           Text("${'notes'.tr()}: ", style: receiptmediumText),
//                           Text(
//                             notes,
//                             maxLines: 2,
//                           ),
//                         ],

//                         // Extras Section
//                         if (hasExtras)
//                           Container(
//                             margin: EdgeInsets.only(top: 5.h),
//                             padding: EdgeInsets.all(5.w),
//                             decoration: BoxDecoration(
//                               color: Colors.goSmartBlue.shade100,
//                               borderRadius: BorderRadius.circular(8.r),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.receipt_long, size: 16, color: Colors.goSmartBlue),
//                                 SizedBox(width: 5.w),
//                                 Text("extra".tr(), style: receiptmediumText.copyWith(color: Colors.goSmartBlue)),
//                               ],
//                             ),
//                           ),

//                         // Discount Section
//                         if (discount > 0)
//                           Container(
//                             margin: EdgeInsets.only(top: 5.h),
//                             padding: EdgeInsets.all(5.w),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade100,
//                               borderRadius: BorderRadius.circular(8.r),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.local_offer, size: 16, color: Colors.green),
//                                 SizedBox(width: 5.w),
//                                 Text(
//                                   "-${discount.toStringAsFixed(2)} ${'egp'.tr()} (${(discount / totalPrice * 100).round()}% ${'discount'.tr()})",
//                                   style: receiptmediumText.copyWith(color: Colors.green),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   //   Expanded(flex: 5, child: Container())
//                 ],
//               ),
//             )
//           :
//           //* IS EXTRA
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//               //    margin: EdgeInsets.symmetric(vertical: 5.h),
//               decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(12.r),
//                 color: Colors.goSmartBlue.shade100,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Title, Edit Icon, and Delete Icon
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: Container(),
//                       ),
//                       //* //*
//                       Expanded(
//                         flex: 4,
//                         child: Text(
//                           context.locale == const Locale('ar') ? nameAr : name,
//                           style: receiptmediumText,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       //*
//                       Expanded(
//                         flex: 3,
//                         child: Row(
//                           children: [
//                             Text("${'units'.tr()}: ", style: receiptmediumText),
//                             Text(quantity.toString(), style: receiptmediumText.copyWith(color: goSmartBlue)),
//                           ],
//                         ),
//                       ),
//                       //*
//                       Expanded(
//                         flex: 1,
//                         child: Text(
//                           "${totalPrice.toStringAsFixed(2)} ${'egp'.tr()}",
//                           style: receiptmediumText.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: goSmartBlue),
//                         ),
//                       ),
//                       //* //*
//                       Expanded(
//                         flex: 1,
//                         child: Container(),
//                       ),
//                     ],
//                   ),

//                   // Extras Section
//                   if (hasExtras)
//                     Container(
//                       margin: EdgeInsets.only(top: 5.h),
//                       padding: EdgeInsets.all(5.w),
//                       decoration: BoxDecoration(
//                         color: Colors.goSmartBlue.shade100,
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.receipt_long, size: 16, color: Colors.goSmartBlue),
//                           SizedBox(width: 5.w),
//                           Text("extra".tr(), style: receiptmediumText.copyWith(color: Colors.goSmartBlue)),
//                         ],
//                       ),
//                     ),

//                   // Discount Section
//                   if (discount > 0)
//                     Container(
//                       margin: EdgeInsets.only(top: 5.h),
//                       padding: EdgeInsets.all(5.w),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade100,
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.local_offer, size: 16, color: Colors.green),
//                           SizedBox(width: 5.w),
//                           Text(
//                             "-${discount.toStringAsFixed(2)} ${'egp'.tr()} (${(discount / totalPrice * 100).round()}% ${'discount'.tr()})",
//                             style: receiptmediumText.copyWith(color: Colors.green),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
