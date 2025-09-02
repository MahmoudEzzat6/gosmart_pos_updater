import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResizeScreen extends StatefulWidget {
  const ResizeScreen({super.key});

  @override
  State<ResizeScreen> createState() => _ResizeScreenState();
}

class _ResizeScreenState extends State<ResizeScreen> {
  Size? selectedSize;

  final List<Size> commonScreenSizes = const [
    Size(800, 600),
    Size(1024, 768),
    Size(1280, 720),
    Size(1366, 768),
    Size(1440, 900),
    Size(1600, 900),
    Size(1920, 1080),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedSize();
  }

  Future<void> _loadSavedSize() async {
    final pref = await SharedPreferences.getInstance();
    final double? width = pref.getDouble('screenWidth');
    final double? height = pref.getDouble('screenHeight');

    if (width != null && height != null) {
      final Size savedSize = Size(width, height);
      setState(() {
        selectedSize = savedSize;
      });

      // Resize the window immediately
      await windowManager.setResizable(true);
      await windowManager.setSize(savedSize);
      await windowManager.center();
      await windowManager.setResizable(false);
    }
  }

  Future<void> _saveAndResize(Size size) async {
    final pref = await SharedPreferences.getInstance();

    // Resize and center the window
    await windowManager.setResizable(true);
    await windowManager.setMaximizable(true);
    await windowManager.setSize(size);
    await windowManager.center();

    // Save the size to SharedPreferences
    await pref.setDouble('screenWidth', size.width);
    await pref.setDouble('screenHeight', size.height);

    // Lock the window to this size
    await windowManager.setResizable(false);
    await windowManager.setMinimumSize(size);
    await windowManager.setMaximumSize(size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resize Window")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<Size>(
                hint: const Text("Select screen size"),
                value: selectedSize,
                items: commonScreenSizes.map((size) {
                  return DropdownMenuItem(
                    value: size,
                    child:
                        Text("${size.width.toInt()} x ${size.height.toInt()}"),
                  );
                }).toList(),
                onChanged: (size) async {
                  if (size == null) return;
                  setState(() => selectedSize = size);
                  await _saveAndResize(selectedSize!);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50.h,
                width: 300.w,
                child: ElevatedButton(
                  onPressed: selectedSize == null
                      ? null
                      : () async {
                          await _saveAndResize(selectedSize!);
                          Navigation().closeDialog(context);
                        },
                  child: const Text('حفظ التعديلات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
