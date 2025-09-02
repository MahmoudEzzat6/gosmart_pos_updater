import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/models/open_cheque_model.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/styles/colors.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class AddTableWidget extends StatefulWidget {
  const AddTableWidget({super.key});

  @override
  State<AddTableWidget> createState() => _AddTableWidgetState();
}

class _AddTableWidgetState extends State<AddTableWidget> {
  var uuid = const Uuid();

  int selectedTableIndex = -1;

  void setSelectedTable(int index) {
    setState(() {
      selectedTableIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final openChequeProviderRead = context.read<OpenChequeProvider>();
    final openChequeProviderWatch = context.watch<OpenChequeProvider>();

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              openChequeProviderRead.closeCheque();
            },
            child: const FittedBox(child: Text('رجوع')),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              openChequeProviderRead.addOpenChequeTable(OpenChequeModel(
                id: uuid.v4(),
                cartItems: [],
                tableName: 'طاولة #${openChequeProviderWatch.openChequesList.length + 1}',
                subtotal: 0.0,
                taxes: 0.0,
                total: 0.0,
              ));
            },
            child: const FittedBox(child: Text('اضافة طاولة')),
          ),
          //* //*
          SizedBox(height: 15.h),
          //* //*
          Expanded(
              child: ListView.builder(
                  itemCount: openChequeProviderWatch.openChequesList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      key: ValueKey(openChequeProviderWatch.openChequesList[index].id),
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setSelectedTable(index);
                        openChequeProviderRead.setSelectedTableId(
                            openChequeProviderWatch.openChequesList[index].id, openChequeProviderWatch.openChequesList[index]);

                        print(openChequeProviderWatch.selectedTableId);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: selectedTableIndex == index ? goSmartBlue : Colors.blueGrey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          openChequeProviderWatch.openChequesList[index].tableName,
                          style: mediumText.copyWith(
                            color: selectedTableIndex == index ? white : Colors.white,
                          ),
                        ),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
