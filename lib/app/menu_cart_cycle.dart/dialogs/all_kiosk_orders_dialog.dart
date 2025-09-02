import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/kiosk_order_details_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/buttons.dart';
import 'package:pos_windows_ice_hub/widget/unclosable_ok_dialog.dart';
import 'package:pos_windows_ice_hub/widget/yes_no_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AllKioskOrdersDialog extends StatelessWidget {
  final ScreenshotController screenshotControllerKiosk;

  const AllKioskOrdersDialog({super.key, required this.screenshotControllerKiosk});

  @override
  Widget build(BuildContext context) {
    final posProviderWatch = context.watch<PosProvider>();
    final posProviderRead = context.read<PosProvider>();
    return AlertDialog(
      content: SizedBox(
        width: AppDimentions().availableWidth * 0.6,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.7),
            itemCount: posProviderWatch.allKioskOrders.data!.length,
            itemBuilder: (context, index) {
              int reverseIndex = posProviderWatch.allKioskOrders.data!.length - 1 - index;

              return Card(
                color: Colors.white,
                elevation: 2,
                shadowColor: goSmartBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            'order_number'.tr(),
                            textAlign: TextAlign.center,
                            style: boldText.copyWith(
                              color: goSmartBlue,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            posProviderWatch.allKioskOrders.data![reverseIndex].id!.toString(),
                            textAlign: TextAlign.center,
                            style: mediumText.copyWith(
                              fontSize: 50.sp,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                              height: 35.h,
                              child: BorderButton(
                                  label: 'show_details'.tr(),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return KioskOrderDetailsDialog(
                                              kioskOrder: posProviderWatch.allKioskOrders.data![reverseIndex]);
                                        });
                                  })),
                          SizedBox(height: 5.h),
                          SizedBox(
                            height: 35.h,
                            child: BlueButton(
                              label: 'submit_order'.tr(),
                              onPressed: () async {
                                //*
                                posProviderRead.setKioskOrdersList =
                                    posProviderWatch.allKioskOrders.data![reverseIndex].orderLines!;

                                posProviderRead.setKioskOrderTotal =
                                    posProviderWatch.allKioskOrders.data![reverseIndex].cartTotal!.toDouble();
                                //*
                                showDialog(
                                    context: context,
                                    builder: (context) => YesNoDialog(
                                        dialogText: 'تأكيد الطلب رقم ${posProviderWatch.allKioskOrders.data![reverseIndex].id}',
                                        onYesPressed: () async {
                                          Navigation().showLoadingGifDialog(context);
//*
                                          await PosApis()
                                              .finishOrderForKioskOrder(
                                                  posProviderWatch.allKioskOrders.data![reverseIndex].sessionId!,
                                                  posProviderWatch.allKioskOrders.data![reverseIndex].paymentMethodId!,
                                                  posProviderRead.currentSession.data![0].cashierId!,
                                                  posProviderRead.customerId,
                                                  false,
                                                  0,
                                                  posProviderWatch.allKioskOrders.data![reverseIndex].orderLines!,
                                                  0,
                                                  context)
                                              .then((value) async {
                                            if (value != null) {
                                              // await posProviderRead
                                              //     .getAllKioskOrders(posProviderWatch.allKioskOrders.data![reverseIndex].sessionId!);

                                              context.read<PosProvider>().setLatestOrderRefrence = value.result!.receiptNumber!;
                                              context.read<PosProvider>().setLatestOrderNumber = value.result!.orderNumber!;

                                              await posProviderRead.processKioskOrder(
                                                  posProviderWatch.allKioskOrders.data![reverseIndex].id!,
                                                  posProviderWatch.allKioskOrders.data![reverseIndex].sessionId!);

                                              //*
                                              Navigator.pop(context);
                                              //*

                                              //* //*
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => UnClosableOkDialog(
                                                      text: 'تم الطلب بنجاح',
                                                      onPressed: () async {
                                                        await context.read<PosProvider>().printReceipt(
                                                            screenshotControllerKiosk, context.read<PosProvider>().isUSBPrinter);

                                                        context.read<MenuProvider>().resetAfterFinishOrder(context);
                                                        //*
                                                        Navigation().closeDialog(context);
                                                        Navigation().closeDialog(context);
                                                      }));
                                            }
                                          });
                                        },
                                        onNoPressed: () {
                                          Navigation().closeDialog(context);
                                        }));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //* //*
                    Positioned(
                      top: -5,
                      right: -5,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    YesNoDialog(dialogText: 'are_you_sure'.tr(), onYesPressed: () {}, onNoPressed: () {}));
                          },
                          icon: const Icon(
                              //Icons.delete
                              Icons.clear,
                              color: Colors.red,
                              size: 25)),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
