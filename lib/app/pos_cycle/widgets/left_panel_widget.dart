// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
// import 'package:pos_windows_ice_hub/styles/colors.dart';
// import 'package:provider/provider.dart';

// import '../../../styles/text_style.dart';

// class LeftPanelWidget extends StatelessWidget {
//   const LeftPanelWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final posProviderWatch = context.watch<PosProvider>();
//     final posProviderRead = context.read<PosProvider>();

//     return Padding(
//       padding: const EdgeInsets.only(top: 20, left: 10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(width: 10.w),
//               Image.asset(
//                 'assets/images/pos.png',
//                 height: 25.h,
//                 width: 25.w,
//               ),
//               SizedBox(width: 10.w),
//               Text(
//                 'GoSmart ',
//                 style: mediumText,
//               ),
//               Text(
//                 'POS',
//                 style: mediumText.copyWith(color: goSmartBlue),
//               ),
//             ],
//           ),
//           //* //*
//           const SizedBox(
//             height: 40,
//           ),
//           //* //*
//           Padding(
//             padding: const EdgeInsets.only(left: 15),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ...List.generate(
//                   posProviderWatch.posCategoriesList.length,
//                   (index) => GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onTap: () {
//                       posProviderRead.changeSelection(posProviderWatch.posCategoriesList[index].name);
//                     },
//                     child: Container(
//                       height: 40,
//                       padding: const EdgeInsets.only(left: 5),
//                       margin: const EdgeInsets.symmetric(vertical: 10),
//                       decoration: BoxDecoration(
//                         color: posProviderWatch.posCategoriesList[index].isSelected ? goSmartBlue.withOpacity(0.15) : null,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Image.asset(
//                             posProviderWatch.posCategoriesList[index].image,
//                             height: 25.h,
//                             width: 25.w,
//                           ),
//                           SizedBox(width: 10.w),
//                           Text(
//                             posProviderWatch.posCategoriesList[index].name,
//                             textAlign: TextAlign.start,
//                             style: mediumText.copyWith(fontSize: 16.sp),
//                           ),
//                           if (posProviderWatch.posCategoriesList[index].isSelected) ...[
//                             const Spacer(),
//                             Container(
//                               width: 2,
//                               color: goSmartBlue,
//                             )
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           //* //*
//           const Spacer(),
//           //* //*
//           Container(
//             height: 40,
//             padding: const EdgeInsets.only(left: 25),
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Image.asset(
//                   'assets/images/Logout.png',
//                   height: 25.h,
//                   width: 25.w,
//                 ),
//                 SizedBox(width: 10.w),
//                 Text(
//                   'Log Out',
//                   textAlign: TextAlign.start,
//                   style: mediumText.copyWith(fontSize: 17.sp, color: const Color(0xff7A8B96)),
//                 ),
//               ],
//             ),
//           ),
//           //* //*
//           const SizedBox(height: 50),
//         ],
//       ),
//     );
//   }
// }

// extension on int {
//   get h => null;
// }
