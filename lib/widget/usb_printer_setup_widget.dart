import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class USBPrinterSetupWidget extends StatefulWidget {
  final bool isFromSettings;

  const USBPrinterSetupWidget({super.key, required this.isFromSettings});

  @override
  State<USBPrinterSetupWidget> createState() => _USBPrinterSetupWidgetState();
}

class _USBPrinterSetupWidgetState extends State<USBPrinterSetupWidget> {
  List<PrinterDevice> devices = [];
  PrinterManager printerManager = PrinterManager.instance;
  PrinterDevice? selectedDevice;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDeviceList();
  }

//*Mahmoud
  Future<void> _getDeviceList() async {
    setState(() {
      isLoading = true;
      devices.clear();
    });

    printerManager.discovery(type: PrinterType.usb).listen((device) {
      setState(() {
        devices.add(device);
      });
    }).onDone(() async {
      setState(() {
        isLoading = false;
      });

      if (!widget.isFromSettings) {
        await printSavedPrinter();
      }
    });
  }

  Future<void> printSavedPrinter() async {
    if (widget.isFromSettings) {
      print(" Manual connect");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final activePrinter = prefs.getString('activePrinter') ?? "";

    if (activePrinter.isEmpty) {
      print("No Active Printers here ");
      return;
    }

    print(" Restoring active printer: $activePrinter");

    final matched = devices.firstWhere(
      (d) => (d.name ?? "").trim() == activePrinter.trim(),
      orElse: () => PrinterDevice(name: ''),
    );

    if (matched.name != null && matched.name!.isNotEmpty) {
      await connectAndSavePrinter(matched);
    } else {
      print("Active printer not found in devices");
    }
  }

//*Mahmoud
  Future<void> connectAndSavePrinter(PrinterDevice device) async {
    context.read<PosProvider>().setPrintName = device.name;
    context.read<PosProvider>().setPrinterManagerUSB = printerManager;
    context.read<PosProvider>().setIsUSBPrinter = true;
    context.read<PosProvider>().setUsePrinter = true;

    final prefs = await SharedPreferences.getInstance();

    //* Save printer in list
    List<String> savedPrinters = prefs.getStringList('savedPrinters') ?? [];
    if (!savedPrinters.contains(device.name)) {
      savedPrinters.add(device.name ?? "");
      await prefs.setStringList('savedPrinters', savedPrinters);
    }

    await prefs.setString('activePrinter', device.name ?? "");

    print(" Printers list: $savedPrinters");
    print(" Active printer: ${device.name}");

    await printTest(device);
    if (mounted && widget.isFromSettings || !widget.isFromSettings) {
      Navigation().closeDialog(context);
    }
    setState(() {
      selectedDevice = device;
    });
  }

  Future<void> printTest(PrinterDevice device) async {
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];

    bytes += generator.setGlobalCodeTable('CP1252');
    bytes += generator.text(
      '${device.name} Ticket',
      styles: const PosStyles(
        align: PosAlign.center,
        fontType: PosFontType.fontA,
        height: PosTextSize.size2,
      ),
    );
    bytes += generator.cut();

    await printerManager.connect(
      type: PrinterType.usb,
      model: UsbPrinterInput(
        name: device.name,
        vendorId: device.vendorId,
        productId: device.productId,
      ),
    );

    await printerManager.send(bytes: bytes, type: PrinterType.usb);
    await printerManager.disconnect(type: PrinterType.usb);
  }

  List<Widget> buildList() {
    return devices.map((device) {
      final isSelected = (selectedDevice?.name == device.name ||
          context.read<PosProvider>().printName == device.name);

      return Card(
        // color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 3,
        child: ListTile(
          contentPadding: EdgeInsets.all(16.w),
          leading: CircleAvatar(
            radius: 30.r,
            backgroundColor: goSmartBlue,
            child: Icon(
              isSelected ? Icons.check_circle : Icons.usb,
              color: white,
            ),
          ),
          title: Text(
            device.name ?? 'Unknown USB Printer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: goSmartBlue,
              fontSize: 25.sp,
            ),
          ),
          // subtitle: Text(
          //   'ID: ${device.vendorId ?? '-'} : ${device.productId ?? '-'}',
          //   style: TextStyle(fontSize: 20.sp, color: Colors.grey[600]),
          // ),
          trailing: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green[700] : goSmartBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(isSelected ? Icons.check : Icons.print),
              ),
              label: Text(
                  isSelected ? 'printer_picked'.tr() : 'choose_printer'.tr()),
              onPressed: () async {
                await connectAndSavePrinter(device);
              }),
        ),
      );
    }).toList();
  }
//*//*//*    //*//*/    /*/*/*/*/

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () {
                Navigation().closeDialog(context);
              },
              icon: const Icon(Icons.close, color: Colors.black)),
        ),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Text(
            'please_pick_printer'.tr(),
            style: mediumText.copyWith(fontSize: 20.sp, color: goSmartBlue),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Center(
            child: SizedBox(
              width: 200.w,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: goSmartBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: _getDeviceList,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'reload'.tr(),
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Center(
            child: SizedBox(
              width: 200.w,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  context.read<PosProvider>().setUsePrinter = false;
                  Navigation().closeDialog(context);
                },
                icon: const Icon(Icons.close),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: FittedBox(
                    child: Text(
                      'dont_use_printer'.tr(),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (devices.isEmpty)
          Padding(
            padding: EdgeInsets.all(40.w),
            child: Text(
              'اضغط اعاده تحميل للبحث عن الطابعات المتصله',
              textAlign: TextAlign.center,
              style: mediumText.copyWith(fontSize: 25.sp),
            ),
          )
        else
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: buildList(),
          ),
      ],
    );
  }
}
