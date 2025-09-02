import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/dialogs/customize_product_dialog.dart';

class CartLineItem {
  int productId;
  double quantity;
  double priceUnit;
  double discount;
  List<int> taxIds;
  String taxesName;
  double priceSubtotalWithoutTax;
  double priceWithTax;
  double qtyAvailable;
  String productName;
  String customerNote;
  String kitchenNote;
  String priceType;
  String selectedSize;
  List<Extras> extras;
  //*
  String extrasString;
  //*
  String description;
  String descriptionAr;
  String image;

  bool isExtra;

  final int selectedSizeIndexEdit;
  final int numOfProductsEdit;
  final List<Extras> selectedExtrasEdit;
  final List<double> extraPriceList;
  final String orderTimeStamp;
  // final String timeStampEdit;

  CartLineItem({
    required this.description,
    required this.descriptionAr,
    required this.image,
    required this.productId,
    required this.qtyAvailable,
    required this.quantity,
    required this.priceUnit,
    required this.discount,
    required this.taxIds,
    required this.taxesName,
    required this.priceSubtotalWithoutTax,
    required this.priceWithTax,
    required this.productName,
    required this.customerNote,
    required this.kitchenNote,
    required this.priceType,
    required this.selectedSize,
    required this.extras,
    //*
    required this.extrasString,
    //*
    required this.isExtra,
    //*
    //*
    required this.extraPriceList,
    required this.selectedSizeIndexEdit,
    required this.selectedExtrasEdit,
    required this.numOfProductsEdit,
    required this.orderTimeStamp,
    // required this.timeStampEdit,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'priceUnit': priceUnit,
      'discount': discount,
      'taxIds': taxIds,
      'priceSubtotalWithoutTax': priceSubtotalWithoutTax,
      'priceWithTax': priceWithTax,
      'qtyAvailable': qtyAvailable,
      'productName': productName,
      'customerNote': customerNote,
      'kitchenNote': kitchenNote,
      'priceType': priceType,
      'selectedSize': selectedSize,
      'extras': extras.map((e) => e.toJson()).toList(),
      'description': description,
      'descriptionAr': descriptionAr,
      'image': image,
      'isExtra': isExtra,
      'selectedSizeIndexEdit': selectedSizeIndexEdit,
      'numOfProductsEdit': numOfProductsEdit,
      'selectedExtrasEdit': selectedExtrasEdit.map((e) => e.toJson()).toList(),
      'extraPriceList': extraPriceList,
      'orderTimeStamp': orderTimeStamp,
    };
  }
}
