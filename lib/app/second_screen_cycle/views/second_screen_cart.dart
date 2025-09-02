// import 'dart:convert';
// import 'dart:developer';

// import 'package:easy_localization/easy_localization.dart' as ez;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/cart_item_widget.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/right_cart_widget.dart';
// import 'package:pos_windows_ice_hub/app/second_screen_cycle/widgets/cart_item_second_screen.dart';
// import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
// import 'package:pos_windows_ice_hub/styles/colors.dart';
// import 'package:pos_windows_ice_hub/styles/text_style.dart';
// import 'package:presentation_displays/secondary_display.dart';
// import 'package:provider/provider.dart';

// class SecondScreenCart extends StatefulWidget {
//   const SecondScreenCart({super.key});

//   @override
//   State<SecondScreenCart> createState() => _SecondScreenCartState();
// }

// class _SecondScreenCartState extends State<SecondScreenCart> {
//   Map<String, dynamic> convertedMapFromFirstScreen = {
//     'data': [],
//   };

//   String dataStringFromFirstScreen = '';

//   var finalCartItemsList = [];

//   final ScrollController _controller = ScrollController();

//   void scrollDown() {
//     _controller.animateTo(
//       _controller.position.maxScrollExtent,
//       duration: const Duration(seconds: 1),
//       curve: Curves.fastOutSlowIn,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppDimentions().appDimentionsInit(context);

//     return Scaffold(
//       body: SecondaryDisplay(
//         callback: (arguments) {
//           log('ARGS: TIME ${ez.DateFormat('hh:mm:ss').format(DateTime.now())} ${arguments.toString()}');

//           dataStringFromFirstScreen = arguments;

//           convertedMapFromFirstScreen = json.decode(dataStringFromFirstScreen);

//           if (convertedMapFromFirstScreen['data'].isEmpty) {
//             //*
//             finalCartItemsList =[ ];

//             setState(() {});
//             //*
//           } else {
//             var itemsList = jsonDecode(convertedMapFromFirstScreen['data']);

//             //* converting extras map

//             itemsList.forEach((element) {
//               element['extra_string'] = jsonDecode(element['extra_string']);

//               log('MM ${element['extra_string']}');
//             });

//             //*

//             finalCartItemsList = itemsList;

//             setState(() {});

//             //* //*

//             _controller.jumpTo(0);
//           }

//           // scrollDown();
//         },
//         child: Directionality(
//           textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
//           child: SizedBox(
//             height: 550,
//             child: finalCartItemsList.isNotEmpty
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       //*
//                       // if (list.isNotEmpty) ...[
//                       //   ...List.generate(list.length, (index) => Text(list[index]['product_name'])),
//                       // ],
//                       //*
//                       if (finalCartItemsList.isNotEmpty) ...[
//                         SizedBox(
//                           height: 530,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 height: AppDimentions().availableheightNoAppBar * 0.08,
//                                 padding: const EdgeInsets.only(left: 10, top: 10, right: 20),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text('${'total'.tr()} : ',
//                                         style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600)),
//                                     Text(
//                                         finalCartItemsList[0]['cart_total'] == null
//                                             ? ''
//                                             : finalCartItemsList[0]['cart_total'].toStringAsFixed(2),
//                                         style: mediumText.copyWith(fontSize: 18.sp)),
//                                     const Spacer(),
//                                     Text(
//                                       ez.DateFormat('E d MMMM yyyy', 'ar').format(DateTime.now()),
//                                       style: GoogleFonts.poppins(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 18.sp,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // SizedBox(height: 5.h),
//                               const Divider(indent: 10, endIndent: 20),
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 height: 470,
//                                 width: AppDimentions().availableWidth,
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   reverse: true,
//                                   controller: _controller,
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: finalCartItemsList.length,
//                                   itemBuilder: (context, index) {
//                                     int reverseIndex = finalCartItemsList.length - 1 - index;

//                                     //int reverseIndex = index;

//                                     return CartItemSecondScreen(
//                                       key: ValueKey(finalCartItemsList[reverseIndex]['product_id']),
//                                       id: finalCartItemsList[reverseIndex]['product_id'],
//                                       name: finalCartItemsList[reverseIndex]['product_name'],
//                                       nameAr: finalCartItemsList[reverseIndex]['product_name'],

//                                       size: finalCartItemsList[reverseIndex]['selected_size'],

//                                       quantity: finalCartItemsList[reverseIndex]['quantity'].toInt(),
//                                       totalPrice: finalCartItemsList[reverseIndex]['price'],
//                                       //    isExtra: finalCartItemsList[reverseIndex]['is_extra'],
//                                       notes: finalCartItemsList[reverseIndex]['customer_note'],
//                                       //*
//                                       description: finalCartItemsList[reverseIndex]['description'],
//                                       descriptionAr: finalCartItemsList[reverseIndex]['descriptionAr'],
//                                       hasExtras: finalCartItemsList[reverseIndex]['has_extra'],
//                                       discount: finalCartItemsList[reverseIndex]['discount'],
//                                       //*
//                                       image: finalCartItemsList[reverseIndex]['image'],
//                                       extraList: finalCartItemsList[reverseIndex]['extra_string'],
//                                       //*
//                                       orderTimeStamp: finalCartItemsList[reverseIndex]['orderTimeStamp'],
//                                     );
//                                   },
//                                 ),
//                               ),

//                               //*
//                             ],
//                           ),
//                         ),
//                       ],
//                     ],
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       //    SizedBox(height: 100.h),
//                       Image.asset(
//                         'assets/images/EmptyState.png',
//                         height: 270.h,
//                         width: 330.w,
//                       ),
//                       Text(
//                         'cart_empty'.tr(),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18.sp,
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Text(
//                         'start_make_order'.tr(),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 18.sp,
//                           color: const Color(0xff7A8B96),
//                         ),
//                       ),
//                       // Spacer(),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }


// //* RECEIPT LIKE DESIGN

// // Container(
// //                             padding: const EdgeInsets.all(10),
// //                             color: bgColor,
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.stretch,
// //                               children: [
// //                                 Text(
// //                                   '${'items'.tr()} (${list.length})',
// //                                   style: mediumText.copyWith(fontSize: 18.sp),
// //                                 ),
// //                                 //*
// //                                 Row(
// //                                   mainAxisAlignment: MainAxisAlignment.start,
// //                                   mainAxisSize: MainAxisSize.max,
// //                                   children: [
// //                                     Expanded(flex: 1, child: Text('quantity'.tr(), style: receiptSmallText)),
// //                                     const Expanded(flex: 1, child: Text('')),
// //                                     Expanded(flex: 2, child: Text('price'.tr(), style: receiptSmallText)),
// //                                     Expanded(flex: 4, child: Text('product_name'.tr(), style: receiptSmallText)),
// //                                     SizedBox(width: 5.w),
// //                                     Expanded(
// //                                         flex: 2,
// //                                         child: Text(
// //                                           'total'.tr(),
// //                                           style: receiptSmallText,
// //                                           maxLines: 1,
// //                                         )),
// //                                   ],
// //                                 ),
// //                                 //*
// //                                 SizedBox(height: 5.h),
// //                                 ...List.generate(
// //                                   list.length,
// //                                   (index) => Padding(
// //                                     padding: const EdgeInsets.symmetric(vertical: 1),
// //                                     child: 
// // Row(
// //                                       mainAxisAlignment: MainAxisAlignment.start,
// //                                       mainAxisSize: MainAxisSize.max,
// //                                       children: [
// //                                         Expanded(
// //                                             flex: 1,
// //                                             child: Text(
// //                                               list[index]['quantity'].toStringAsFixed(0),
// //                                               style: receiptSmallText,
// //                                               textAlign: TextAlign.center,
// //                                             )),
// //                                         Expanded(flex: 1, child: Text('x', style: receiptSmallText)),
// //                                         Expanded(
// //                                             flex: 2,
// //                                             child: Text(list[index]['unit_price'].toStringAsFixed(2), style: receiptSmallText)),
// //                                         Expanded(flex: 4, child: Text(list[index]['product_name'], style: receiptSmallText)),
// //                                         SizedBox(width: 5.w),
// //                                         Expanded(
// //                                             flex: 2,
// //                                             child: Text(
// //                                               list[index]['price'].toStringAsFixed(2),
// //                                               style: receiptSmallText,
// //                                               maxLines: 1,
// //                                             )),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
                              
// //                               ],
// //                             ),
// //                           ),




// //* //* OLD CART DESIGN

//   // ListView.builder(
//                                 //   shrinkWrap: true,
//                                 //   physics: const NeverScrollableScrollPhysics(),
//                                 //   itemCount: list.length,
//                                 //   itemBuilder: (context, index) {
//                                 //     return CartItemSecondScreen(
//                                 //       key: ValueKey(list[index]['product_id']),
//                                 //       id: list[index]['product_id'],
//                                 //       name: list[index]['product_name'],
//                                 //       nameAr: list[index]['product_name'],

//                                 //       size: list[index]['selected_size'],

//                                 //       quantity: list[index]['quantity'].toInt(),
//                                 //       totalPrice: list[index]['price'],
//                                 //       isExtra: list[index]['is_extra'],
//                                 //       notes: list[index]['customer_note'],
//                                 //       //*
//                                 //       description: list[index]['description'],
//                                 //       descriptionAr: list[index]['descriptionAr'],
//                                 //       hasExtras: list[index]['has_extra'],
//                                 //       discount: list[index]['discount'],
//                                 //       //*
//                                 //     );
//                                 //   },
//                                 // ),







// //* //* //*

//   // Expanded(
//                         //   child: ListView.builder(
//                         //       itemCount: list.length,
//                         //       itemBuilder: (context, index) {
//                         //         return Row(
//                         //           mainAxisAlignment: MainAxisAlignment.start,
//                         //           mainAxisSize: MainAxisSize.max,
//                         //           children: [
//                         //             Expanded(flex: 1, child: Image.network(list[index]['image'])),
//                         //             Expanded(flex: 3, child: Text(list[index]['product_name'], style: receiptSmallText)),
//                         //             Expanded(
//                         //                 flex: 1,
//                         //                 child: Text(
//                         //                   list[index]['quantity'].toStringAsFixed(0),
//                         //                   style: receiptSmallText,
//                         //                   textAlign: TextAlign.center,
//                         //                 )),
//                         //             Expanded(flex: 1, child: Text('x', style: receiptSmallText)),
//                         //             Expanded(
//                         //                 flex: 2,
//                         //                 child: Text(list[index]['unit_price'].toStringAsFixed(2), style: receiptSmallText)),
//                         //             SizedBox(width: 5.w),
//                         //             Expanded(
//                         //                 flex: 2,
//                         //                 child: Text(
//                         //                   list[index]['price'].toStringAsFixed(2),
//                         //                   style: receiptSmallText,
//                         //                   maxLines: 1,
//                         //                 )),
//                         //           ],
//                         //         );
//                         //       }),
//                         //  )