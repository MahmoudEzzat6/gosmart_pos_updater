// import 'package:dotted_line/dotted_line.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/delete_pos_dialog.dart' show DeletePosDialog;
// import 'package:pos_windows_ice_hub/app/pos_cycle/dialogs/edit_pos_session_dialog.dart';
// import 'package:pos_windows_ice_hub/styles/text_style.dart';

// class PosItemWidgetTwo extends StatelessWidget {
//   const PosItemWidgetTwo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15),
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24.r),
//         side: const BorderSide(
//           color: Color(0xffFFDFBD),
//         ),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24.r),
//           // border: Border.all(
//           //   color: const Color(0xffFFDFBD),
//           // ),
//           gradient: const LinearGradient(
//             colors: [
//               Color(0xffFEF2E7),
//               Color(0xffFBFBFB),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Shop Branch Nasr City #3',
//               textAlign: TextAlign.center,
//               style: mediumText,
//             ),
//             const Divider(
//               color: Color(0xffFFDFBD),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 // Container(
//                 //   alignment: Alignment.center,
//                 //   height: 30.h,
//                 //   width: 30.w,
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(8.r),
//                 //     color: Colors.green.withOpacity(0.25),
//                 //   ),
//                 //   child: Text(
//                 //     'A',
//                 //     textAlign: TextAlign.center,
//                 //     style: mediumText.copyWith(color: Colors.green),
//                 //   ),
//                 // ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) => const EditPosSessionDialog(
//                               posName: 'Shop Branch Nasr City #3',
//                             ));
//                   },
//                   child: Image.asset(
//                     'assets/images/edit.png',
//                     height: 25.h,
//                     width: 25.w,
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 GestureDetector(
//                   onTap: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) => const DeletePosDialog(
//                               posName: 'Shop Branch Nasr City #3',
//                             ));
//                   },
//                   child: Image.asset(
//                     'assets/images/bin.png',
//                     height: 25.h,
//                     width: 25.w,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Text(
//                   'Balance',
//                   style: mediumText,
//                 ),
//                 const Spacer(),
//                 Text(
//                   '0.0 EGP',
//                   style: mediumText.copyWith(
//                     color: Colors.grey[700],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Text(
//                   'Closing',
//                   style: mediumText,
//                 ),
//                 const Spacer(),
//                 // Text(
//                 //   DateFormat('dd/MM/yyyy  h:m a').format(DateTime.now()),
//                 //   style: mediumText.copyWith(
//                 //     color: Colors.grey[700],
//                 //   ),
//                 // ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             const DottedLine(),
//             const Spacer(),
//             Container(
//               height: 40.h,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.r),
//                 gradient: const LinearGradient(
//                   colors: [
//                     Color(0xffFFC78A),
//                     Color(0xfffff4e9),
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: Text(
//                 'New Session',
//                 style: mediumText,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
