import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:provider/provider.dart';

class SelectedPaymentMethodWidget extends StatefulWidget {
  const SelectedPaymentMethodWidget({super.key});

  @override
  State<SelectedPaymentMethodWidget> createState() => _SelectedPaymentMethodWidgetState();
}

class _SelectedPaymentMethodWidgetState extends State<SelectedPaymentMethodWidget> {
  int selectedIndex = -1;

  void setSelectedItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final posProviderRead = context.read<PosProvider>();

      if (posProviderRead.isDeliveryOrder) {
        //*
        posProviderRead.availablePaymentMethods.data!.firstWhere((element) {
          // print('${element.name} -- ${posProviderRead.isDeliveryOrder}');
          if (element.name!.toLowerCase().contains('delivery')) {
            //*
            setSelectedItem(posProviderRead.availablePaymentMethods.data!.indexOf(element));
            posProviderRead.setSelectedPaymentMethod(element.id!, element.name!);
            //*
          }
          return element.name!.toLowerCase().contains('delivery');
        });
        //*
      } else {
        //*
        posProviderRead.availablePaymentMethods.data!.firstWhere((element) {
          // print('${element.name} -- ${posProviderRead.isDeliveryOrder}');
          if (element.name!.toLowerCase().contains('cash')) {
            //*
            setSelectedItem(posProviderRead.availablePaymentMethods.data!.indexOf(element));
            posProviderRead.setSelectedPaymentMethod(element.id!, element.name!);
            //*
          }
          return element.name!.toLowerCase().contains('cash');
        });
        //*
      }
      //* //* //* //*
      log('selected PaymentMethodID: ${posProviderRead.selectedPaymentMethodId}');
      log('selected PaymentMethodName: ${posProviderRead.selectedPaymentMethodName}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final posProviderWatch = context.watch<PosProvider>();

    return Container(
      child: posProviderWatch.selectedPaymentMethodName.toLowerCase() != 'delivery'
          ? GridView.builder(
              itemCount: posProviderWatch.availablePaymentMethods.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 6, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) => GestureDetector(
                onTap: posProviderWatch.availablePaymentMethods.data![index].name!.toLowerCase() == 'delivery'
                    ? () {
                        showDialog(
                            context: context,
                            builder: (context) => OkDialog(
                                  text: 'هذا الاختيار متاح فقط لطلبات التوصيل',
                                  onPressed: () {
                                    Navigation().closeDialog(context);
                                  },
                                ));
                      }
                    : () {
                        setSelectedItem(index);

                        context.read<PosProvider>().setSelectedPaymentMethod(
                            posProviderWatch.availablePaymentMethods.data![index].id!,
                            posProviderWatch.availablePaymentMethods.data![index].name!);

                        print(
                            'Selected payment method: ${posProviderWatch.availablePaymentMethods.data![index].name} -- ID: ${posProviderWatch.availablePaymentMethods.data![index].id}');
                      },
                child: Container(
                  key: ValueKey(posProviderWatch.availablePaymentMethods.data![index].id),
                  alignment: Alignment.center,
                  width: 150.w,
                  //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedIndex == index ? goSmartBlue : white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color.fromRGBO(225, 225, 225, 1),
                    ),
                  ),
                  child: Text(
                    posProviderWatch.availablePaymentMethods.data![index].name!.toLowerCase().contains('cash')
                        ? 'Cash'
                        : posProviderWatch.availablePaymentMethods.data![index].name!,
                    style: mediumText.copyWith(
                      color: selectedIndex == index ? white : black,
                    ),
                  ),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 60.h,
                  width: 150.w,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: goSmartBlue,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color.fromRGBO(225, 225, 225, 1),
                    ),
                  ),
                  child: Text(
                    posProviderWatch.selectedPaymentMethodName,
                    style: mediumText.copyWith(
                      color: white,
                    ),
                  ),
                ),
              ],
            ),
    );

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     ...List.generate(
    //       posProviderWatch.availablePaymentMethods.data!.length,
    //       (index) => GestureDetector(
    //         onTap: () {
    //           setSelectedItem(index);
    //         },
    //         child: Container(
    //           key: ValueKey(posProviderWatch.availablePaymentMethods.data![index].id),
    //           alignment: Alignment.center,
    //           width: 150.w,
    //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //           decoration: BoxDecoration(
    //             color: white,
    //             borderRadius: BorderRadius.circular(10.r),
    //             border: Border.all(
    //               color: const Color.fromRGBO(225, 225, 225, 1),
    //             ),
    //           ),
    //           child: Text(
    //             posProviderWatch.availablePaymentMethods.data![index].name!,
    //             style: mediumText,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
