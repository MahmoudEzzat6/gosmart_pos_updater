// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/customize_product_dialog.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/product_tax.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/providers/menu_provider.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/services/menu_apis.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/provider/open_cheque_provider.dart';
import 'package:pos_windows_ice_hub/helpers/application_dimentions.dart';
import 'package:pos_windows_ice_hub/helpers/localized_helper.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/styles/text_style.dart';
import 'package:pos_windows_ice_hub/widget/ok_dialog.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../styles/colors.dart';
import '../../../widget/buttons.dart';

class CustomizeOpenProductDialog extends StatefulWidget {
  final String tableID;
  //*
  final int productId;
  final String name;
  final String nameAr;
  final String image;
  //final double price;
  final String description;
  final String descriptionAr;
  final List<int> taxesId;
  final double quantityAvailable;
  //* //*
  final bool isEdit;
  //* //* //*
  //* FROM EDIT PRODUCT
  final int? selectedSizeIndexEdit;
  final int? numOfProductsEdit;
  final List<Extras>? selectedExtrasEdit;
  final List<double>? extraPriceListEdit;
  final String? customerNote;
  final String? orderTimeStampEdit;
  //* //*
  final bool isOthers;

  //* //*

  // final DisplayManager? displayManager;

  const CustomizeOpenProductDialog({
    super.key,
    //*
    required this.tableID,
    //*
    required this.name,
    required this.image,
    //required this.price,
    required this.productId,
    required this.description,
    required this.descriptionAr,
    required this.taxesId,
    required this.isEdit,
    //* //* //*
    this.selectedSizeIndexEdit,
    this.selectedExtrasEdit,
    this.extraPriceListEdit,
    this.numOfProductsEdit,
    this.customerNote,
    this.orderTimeStampEdit,
    required this.quantityAvailable,
    required this.nameAr,
    // this.displayManager,
    required this.isOthers,
  });

  @override
  State<CustomizeOpenProductDialog> createState() => _CustomizeOpenProductDialogState();
}

class _CustomizeOpenProductDialogState extends State<CustomizeOpenProductDialog> {
  //*
  final priceController = TextEditingController();
  final priceNode = FocusNode();
  //*
  bool dataLoaded = false;
  bool isError = false;
  int numOfProducts = 1;

  List<String> sizeList = [];
  int selectedSizeIndex = 0;
  List<double> sizePriceList = [];

  List<Extras> extraList = [];
  List<double> extraPriceList = [];

  List<Extras> selectedExtras = [];
  double totalExtrasCalc = 0;

  double totalVariantsCalc = 0;

  final notesController = TextEditingController();

  double taxAmount = 0.0;

  String orderTimeStamp = intl.DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        await initData();
      } catch (e) {
        setState(() {
          isError = true;
          dataLoaded = true;
        });
      }
    });
  }

  Future<void> initData() async {
    dataLoaded = false;

    setState(() {});
    //*
    await context.read<MenuProvider>().getProductDetails(widget.productId);

    if (widget.taxesId.isNotEmpty) {
      ProductTax? productTax = await MenuApis().getProductTax(widget.taxesId[0]);
      taxAmount = productTax!.data![0].amount!;
    }
    print('EDIT >> ${widget.isEdit}');
    final menuProviderRead = context.read<MenuProvider>();

    // Clear lists before populating
    sizeList.clear();
    sizePriceList.clear();
    extraList.clear();
    extraPriceList.clear();

    // Populate sizeList and sizePriceList based on product sizes
    final product = menuProviderRead.productDetails.data![0];

    if (product.small == true) {
      sizeList.add('small'.tr());
      sizePriceList.add(product.smallPrice ?? 0);
    }

    if (product.medium == true) {
      sizeList.add('medium'.tr());
      sizePriceList.add(product.mediumPrice ?? 0);
    }

    if (product.large == true) {
      sizeList.add('large'.tr());
      sizePriceList.add(product.largePrice ?? 0);
    }

    //* //*
    if (product.small == false && product.medium == false && product.large == false) {
      sizeList.add('');
      sizePriceList.add(product.listPrice!);
    }

    // Populate extraList and extraPriceList
    for (var element in product.extras!) {
      extraList.add(Extras(
          attachedProductId: widget.productId,
          qtyAvailable: widget.quantityAvailable,
          extraId: element.variantProductId!,
          quantity: numOfProducts.toDouble(),
          priceUnit: element.listPrice!,
          discount: 0.0,
          taxIds: element.taxesId!,
          priceSubtotalWithoutTax: element.listPrice! * numOfProducts,
          priceWithTax:
              calculatePriceWithTax(element.listPrice!, numOfProducts.toDouble(), element.taxesId!.isEmpty ? 0 : taxAmount),
          productName: element.name!,
          productNameAr: element.nameAr!,
          customerNote: '',
          kitchenNote: '',
          priceType: 'original',
          selectedSize: sizeList[selectedSizeIndex]));

      extraPriceList.add(element.listPrice!);
    }

    // Ensure selectedSizeIndex is within bounds
    if (sizePriceList.isNotEmpty) {
      selectedSizeIndex = 0; // Reset to first item
    } else {
      selectedSizeIndex = -1; // No valid selection
    }

    //* //* //* //*
    if (widget.isEdit) {
      numOfProducts = widget.numOfProductsEdit ?? 1;
      selectedSizeIndex = widget.selectedSizeIndexEdit ?? 0;
      extraPriceList = widget.extraPriceListEdit ?? [];
      selectedExtras = widget.selectedExtrasEdit ?? [];

      notesController.text = widget.customerNote ?? '';

      // for (var element in extraList) {
      //   setExtraSelection(element);
      // }
    }

    setState(() {
      dataLoaded = true;
      isError = false;
    });
  }

  void setSizeSelection(int index) {
    setState(() {
      selectedSizeIndex = index;
    });
  }

  List<String> extrasMapList = [];

  void setExtraSelection(Extras extra) {
    totalExtrasCalc = 0;

    if (selectedExtras.any((extraObj) => extraObj.productName == extra.productName)) {
      selectedExtras.removeWhere((test) => test.productName == extra.productName);

      //   extrasMapList.removeWhere((element) => element.contains(extra.productName));
    } else {
      //*
      //* ADD EXTRA TO MAP
      //*
      // var dataMap = {
      //   'product_id': extra.extraId,
      //   'product_name': extra.productName,
      //   'quantity': numOfProducts,
      //   'unit_price': extra.priceUnit,
      //   'price': extra.priceWithTax
      // };

      // print('''

      //   'product_id': ${extra.extraId},
      //   'product_name': ${extra.productName},
      //   'quantity': $numOfProducts,
      //   'unit_price': ${extra.priceUnit},
      //   'price': ${extra.priceWithTax}

      //       ''');

      // extrasMapList.add(json.encode(dataMap));
      //*
      //*

      selectedExtras.add(Extras(
          attachedProductId: widget.productId,
          qtyAvailable: widget.quantityAvailable,
          extraId: extra.extraId,
          quantity: extra.quantity,
          priceUnit: extra.priceUnit,
          discount: extra.discount,
          productNameAr: extra.productNameAr,
          taxIds: extra.taxIds,
          priceSubtotalWithoutTax: extra.priceSubtotalWithoutTax,
          priceWithTax: extra.priceWithTax,
          productName: extra.productName,
          customerNote: extra.customerNote,
          kitchenNote: extra.kitchenNote,
          priceType: extra.priceType,
          selectedSize: extra.selectedSize));
    }

    for (var value in selectedExtras) {
      //  print('extra: ${value.productName} - ${value.priceUnit}');
      totalExtrasCalc += value.priceUnit;
    }

    setState(() {});
  }

  // Add a method to calculate the total price
  double calculateTotalPrice() {
    double totalExtras = 0;

    // Calculate total extras
    for (var extra in selectedExtras) {
      totalExtras += extra.priceWithTax;
    }

    // Calculate total price
    double sizePrice = sizePriceList.isNotEmpty ? sizePriceList[selectedSizeIndex] : 1;
    double totalPrice = (sizePrice * numOfProducts) + (totalExtras * numOfProducts);

    return totalPrice;
  }

  double calculatePriceWithTax(double subtotal, double quantity, double taxRate) {
    double priceWithTax = (subtotal * quantity) * (1 + taxRate / 100);
    return priceWithTax;
  }

  //* ADD TO CART
  void addToCart() {
    //*
    // final menuProviderRead = context.read<MenuProvider>();
    final openChequeProviderRead = context.read<OpenChequeProvider>();
    //*
    //* //* //* //*

    selectedExtras.forEach((extraElement) {
      Map<String, dynamic> singleDataMap = {
        'product_id': extraElement.extraId,
        'product_name': context.locale == const Locale('ar')
            ? extraElement.productNameAr.isEmpty
                ? extraElement.productName
                : extraElement.productNameAr
            : extraElement.productName,
        'quantity': numOfProducts,
        'unit_price': extraElement.priceUnit,
        'price': extraElement.priceWithTax,
      };

      // print('''

      //   'product_id': ${element.extraId},
      //   'product_name': ${element.productName},
      //   'quantity': $numOfProducts,
      //   'unit_price': ${element.priceUnit},
      //   'price': ${element.priceWithTax}

      //       ''');

      String encodedDataMap = json.encode(singleDataMap);

      print('encodedDataMap >> $encodedDataMap');

      extrasMapList.add(encodedDataMap);
    });
    //*
    //*
    openChequeProviderRead.addItemToCart(
        widget.tableID,
        CartLineItem(
          //TODO
          //  taxesName: menuProviderRead.productDetails.data![0].taxesName ?? '',
          taxesName: '',
          productId: widget.productId,
          qtyAvailable: widget.quantityAvailable,
          quantity: numOfProducts.toDouble(),
          priceUnit: widget.isOthers ? double.parse(priceController.text) : sizePriceList[selectedSizeIndex],
          discount: 0.0,
          taxIds: widget.taxesId,
          priceSubtotalWithoutTax:
              widget.isOthers ? double.parse(priceController.text) : (sizePriceList[selectedSizeIndex] * numOfProducts),
          priceWithTax: widget.isOthers
              ? double.parse(priceController.text)
              : calculatePriceWithTax(
                  sizePriceList[selectedSizeIndex], numOfProducts.toDouble(), widget.taxesId.isEmpty ? 0 : taxAmount),
          productName: context.localizedValue(en: widget.name, ar: widget.nameAr),
          customerNote: notesController.text,
          selectedSize: sizeList[selectedSizeIndex],
          kitchenNote: '',
          priceType: 'original',
          extras: selectedExtras,
          //*
          extrasString: jsonEncode(extrasMapList),
          //*
          isExtra: false,
          //* //*
          description: widget.description,
          descriptionAr: widget.descriptionAr,
          image: widget.image,
          //* //*
          extraPriceList: extraPriceList,
          selectedExtrasEdit: selectedExtras,
          selectedSizeIndexEdit: selectedSizeIndex,
          numOfProductsEdit: numOfProducts,
          orderTimeStamp: orderTimeStamp,
        ));

    //*
    //* PRINT EXTRAS AND ADD THEM TO CART
    for (var element in selectedExtras) {
//*

      log('''
                                            productId: ${element.extraId},
                                            quantity: ${numOfProducts.toDouble()},
                                            priceUnit: ${element.priceUnit},
                                            discount: 0.0,
                                            taxIds: ${element.taxIds},
                                            priceSubtotalWithoutTax: ${element.priceUnit * numOfProducts}
                                             priceWithTax: ${calculatePriceWithTax(element.priceUnit, numOfProducts.toDouble(), element.taxIds.isEmpty ? 0 : taxAmount)},
                                            productName: ${element.productName},
                                            customerNote: '',
                                            kitchenNote: '',
                                            priceType: 'original'
                                            ''');

      openChequeProviderRead.addItemToCart(
          widget.tableID,
          CartLineItem(
            //TODO
            //   taxesName: menuProviderRead.productDetails.data![0].taxesName ?? '',
            taxesName: '',
            productId: element.extraId,
            qtyAvailable: widget.quantityAvailable,
            quantity: numOfProducts.toDouble(),
            priceUnit: element.priceUnit,
            discount: 0.0,
            taxIds: element.taxIds,
            priceSubtotalWithoutTax: element.priceUnit * numOfProducts,
            priceWithTax:
                calculatePriceWithTax(element.priceUnit, numOfProducts.toDouble(), element.taxIds.isEmpty ? 0 : taxAmount),
            productName: context.locale == const Locale('ar')
                ? element.productNameAr.isEmpty
                    ? element.productName
                    : element.productNameAr
                : element.productName,

            customerNote: '',
            selectedSize: sizeList[selectedSizeIndex],
            kitchenNote: '',
            priceType: 'original',
            extras: [],
            extrasString: '',
            isExtra: true,
            //* //*
            description: widget.description,
            descriptionAr: widget.descriptionAr,
            image: widget.image,
            //* //*
            extraPriceList: extraPriceList,
            selectedExtrasEdit: selectedExtras,
            selectedSizeIndexEdit: selectedSizeIndex,
            numOfProductsEdit: numOfProducts,
            orderTimeStamp: orderTimeStamp,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimentions().appDimentionsInit(context);

    final menuProviderRead = context.read<MenuProvider>();
    return AlertDialog(
      content: isError
          ? SizedBox(
              width: AppDimentions().availableWidth * 0.45,
              child: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await initData();
                    },
                    child: const Text('حدث خطأ برجاء اعاده التحميل')),
              ),
            )
          : SingleChildScrollView(
              // Wrap the content in a SingleChildScrollView
              child: Directionality(
                textDirection: context.locale == const Locale('ar') ? TextDirection.rtl : TextDirection.ltr,
                child: SizedBox(
                  width: AppDimentions().availableWidth * 0.45,
                  child: dataLoaded
                      ? Column(
                          mainAxisSize: MainAxisSize.min, // Use min to avoid taking up unnecessary space
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  onPressed: () {
                                    Navigation().closeDialog(context);
                                  },
                                  icon: const Icon(Icons.close, color: Colors.black)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: AppDimentions().availableWidth * 0.45,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Product Image and Details
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Container(
                                          //   height: 110.h,
                                          //   width: 110.w,
                                          //   padding: const EdgeInsets.all(8),
                                          //   decoration: BoxDecoration(
                                          //     color: lightOrange,
                                          //     borderRadius: BorderRadius.circular(15.r),
                                          //   ),
                                          //   child: Image.network(
                                          //     widget.image,
                                          //     height: 100.h,
                                          //     width: 100.w,
                                          //     color: widget.isOthers ? Colors.grey.withOpacity(0.5) : null,
                                          //     fit: BoxFit.contain,
                                          //     errorBuilder: (context, error, stackTrace) {
                                          //       return Image.asset(
                                          //         ' ', // Placeholder image
                                          //         height: 100.h,
                                          //         width: 100.w,
                                          //         fit: BoxFit.cover,
                                          //       );
                                          //     },
                                          //     loadingBuilder: (context, child, loadingProgress) {
                                          //       if (loadingProgress == null) return child;
                                          //       return SizedBox(
                                          //         height: 100.h,
                                          //         width: 100.w,
                                          //         child: Center(
                                          //           child: CircularProgressIndicator(
                                          //             color: goSmartBlue,
                                          //             value: loadingProgress.expectedTotalBytes != null
                                          //                 ? loadingProgress.cumulativeBytesLoaded /
                                          //                     (loadingProgress.expectedTotalBytes ?? 1)
                                          //                 : null,
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //   ),
                                          // ),
                                          // SizedBox(width: 10.w),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                context.locale == const Locale('ar')
                                                    ? widget.nameAr.isEmpty
                                                        ? widget.name
                                                        : widget.nameAr
                                                    : widget.name,
                                                style: mediumText,
                                              ),
                                              SizedBox(height: 5.h),
                                              SizedBox(
                                                width: AppDimentions().availableWidth * 0.35,
                                                child: Text(
                                                  context.locale == const Locale('ar')
                                                      ? widget.descriptionAr
                                                      : widget.description,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Price and Quantity
                                      if (!widget.isOthers)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              flex: 7,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    calculateTotalPrice().toStringAsFixed(2),
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 25.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: goSmartBlue,
                                                    ),
                                                  ),
                                                  Text(
                                                    '  ${'egp'.tr()}',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: goSmartBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (numOfProducts > 1) {
                                                    numOfProducts--;
                                                    setState(() {});
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.indeterminate_check_box_outlined,
                                                  size: 50,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                '$numOfProducts',
                                                textAlign: TextAlign.center,
                                                style: mediumText.copyWith(
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (numOfProducts < widget.quantityAvailable) {
                                                    numOfProducts++;
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => OkDialog(
                                                              text: 'max_quantity'.tr(),
                                                              onPressed: () {
                                                                Navigation().closeDialog(context);
                                                              },
                                                            ));
                                                  }
                                                  setState(() {});
                                                },
                                                child: const Icon(
                                                  Icons.add_box,
                                                  size: 50,
                                                  color: goSmartBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: TextField(
                                            controller: priceController,
                                            focusNode: priceNode,
                                            keyboardType: TextInputType.number,
                                            textInputAction: TextInputAction.done,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                filled: true,
                                                fillColor: Colors.grey[150],
                                                border: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    borderSide: BorderSide.none),
                                                enabledBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    borderSide: BorderSide.none),
                                                errorBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    borderSide: BorderSide.none),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    borderSide: BorderSide.none),
                                                label: Text(
                                                  'price'.tr(),
                                                  style: smallText,
                                                ),
                                                alignLabelWithHint: true),
                                          ),
                                        ),

                                      // Size Selection

                                      if (widget.isOthers == false) ...[
                                        if (sizeList.isNotEmpty) ...[
                                          const Divider(thickness: 4),
                                          Text('size'.tr(), style: mediumText),
                                          ...List.generate(
                                            sizeList.length,
                                            (index) => GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                setSizeSelection(index);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 3),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      sizeList[index],
                                                      style: mediumText.copyWith(
                                                        color: Colors.grey[700],
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '( ${((sizePriceList.isNotEmpty ? sizePriceList[index] : 0)).toStringAsFixed(2)} ${'egp'.tr()} )',
                                                      style: mediumText.copyWith(
                                                        color: Colors.grey[700],
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Container(
                                                      height: 25,
                                                      width: 25,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: selectedSizeIndex == index ? goSmartBlue : Colors.grey,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: selectedSizeIndex == index
                                                            ? Container(
                                                                height: 15,
                                                                width: 15,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: selectedSizeIndex == index ? goSmartBlue : Colors.grey,
                                                                ),
                                                              )
                                                            : Container(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]
                                      ],
                                      // Extra Selection
                                      if (extraList.isNotEmpty) ...[
                                        const Divider(thickness: 4),
                                        Text('extra'.tr(), style: mediumText)
                                      ],
                                      ...List.generate(
                                        extraList.length,
                                        (index) => GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // print(extraList[index].extraId);
                                            // print(extraList[index].attachedProductId);
                                            setExtraSelection(extraList[index]);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 3),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  context.locale == const Locale('ar')
                                                      ? extraList[index].productNameAr.isEmpty
                                                          ? extraList[index].productName
                                                          : extraList[index].productNameAr
                                                      : extraList[index].productName,
                                                  style: mediumText.copyWith(
                                                    color: Colors.grey[700],
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '( ${(extraPriceList[index]).toStringAsFixed(2)} ${'egp'.tr()} )',
                                                  style: mediumText.copyWith(
                                                    color: Colors.grey[700],
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: selectedExtras.any(
                                                              (extraObj) => extraObj.productName == extraList[index].productName)
                                                          ? goSmartBlue
                                                          : Colors.grey,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: selectedExtras.any(
                                                            (extraObj) => extraObj.productName == extraList[index].productName)
                                                        ? Container(
                                                            height: 15,
                                                            width: 15,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: selectedExtras.any((extraObj) =>
                                                                      extraObj.productName == extraList[index].productName)
                                                                  ? goSmartBlue
                                                                  : Colors.grey,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Variants Selection (only show if isVariant is true)

                                      // Notes
                                      SizedBox(height: 5.h),
                                      TextField(
                                        controller: notesController,
                                        maxLines: 1,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          hintText: 'add_note'.tr(),
                                          filled: true,
                                          fillColor: white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15.r),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      // Continue Button
                                      BlueButton(
                                        label: 'continue'.tr(),
                                        onPressed: () {
                                          log('''
                                            productId: ${widget.productId},
                                            quantity: ${numOfProducts.toDouble()},
                                            priceUnit: ${sizePriceList[selectedSizeIndex]},
                                            discount: 0.0,
                                            taxIds: ${widget.taxesId},
                                            priceSubtotalWithoutTax: ${sizePriceList[selectedSizeIndex] * numOfProducts}
                                             priceWithTax: ${calculatePriceWithTax(sizePriceList[selectedSizeIndex], numOfProducts.toDouble(), widget.taxesId.isEmpty ? 0 : taxAmount)},
                                            productName: ${widget.nameAr.isEmpty ? widget.name : widget.nameAr},
                                            customerNote: ${notesController.text},
                                            kitchenNote: '',
                                            priceType: 'original'
                                            ''');

                                          //  double totalExtras = 0;

                                          // for (var value in selectedExtras) {
                                          //   print('extra: ${value.productName} - ${value.priceWithTax}');
                                          //   totalExtras += value.priceWithTax;
                                          // }

                                          // double totalPrice =
                                          //     (numOfProducts * (sizePriceList.isNotEmpty ? sizePriceList[selectedSizeIndex] : 0)) +
                                          //         (totalExtras * numOfProducts);

                                          //*
                                          //* IF ADD TO CART
                                          if (widget.isEdit == false) {
                                            addToCart();
                                          }
                                          //* IF IS EDIT
                                          else {
                                            menuProviderRead.removeFromCart(widget.orderTimeStampEdit!);

                                            addToCart();
                                          }
                                          //*

                                          menuProviderRead.getCartTotal();

                                          Navigation().closeDialog(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: goSmartBlue,
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}

// class Extras {
//   final int attachedProductId;
//   final int extraId;
//   final double quantity;
//   final double priceUnit;
//   final double discount;
//   final List<int> taxIds;
//   final double qtyAvailable;
//   final double priceSubtotalWithoutTax;
//   final double priceWithTax;
//   final String productName;
//   final String productNameAr;
//   final String customerNote;
//   final String kitchenNote;
//   final String priceType;
//   final String selectedSize;

//   Extras({
//     required this.attachedProductId,
//     required this.extraId,
//     required this.productNameAr,
//     required this.quantity,
//     required this.priceUnit,
//     required this.discount,
//     required this.taxIds,
//     required this.priceSubtotalWithoutTax,
//     required this.priceWithTax,
//     required this.productName,
//     required this.customerNote,
//     required this.kitchenNote,
//     required this.priceType,
//     required this.selectedSize,
//     required this.qtyAvailable,
//   });
// }

// extension ExtrasJson on Extras {
//   Map<String, dynamic> toJson() {
//     return {
//       'attachedProductId': attachedProductId,
//       'extraId': extraId,
//       'quantity': quantity,
//       'priceUnit': priceUnit,
//       'discount': discount,
//       'taxIds': taxIds,
//       'qtyAvailable': qtyAvailable,
//       'priceSubtotalWithoutTax': priceSubtotalWithoutTax,
//       'priceWithTax': priceWithTax,
//       'productName': productName,
//       'productNameAr': productNameAr,
//       'customerNote': customerNote,
//       'kitchenNote': kitchenNote,
//       'priceType': priceType,
//       'selectedSize': selectedSize,
//     };
//   }
// }
