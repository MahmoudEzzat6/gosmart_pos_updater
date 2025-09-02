import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/all_products.dart' as all;
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/categories.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/product_details.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/variants.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/services/menu_apis.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/widgets/menu_middle_widget.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/discount_model.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/providers/pos_provider.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';

class MenuProvider with ChangeNotifier {
  //* VARIABLES

  Categories _categories = Categories();
  int _firstSelectedCategory = 0;

  Products _selectedProductsList = Products();

  ProductDetails _productDetails = ProductDetails();
  Variants _variant = Variants();

  bool _menuItemsLoaded = true;
  bool _menuItemsError = false;

  // CART
  List<CartLineItem> _cartLineItems = [];
  double _cartTotal = 0.0;
  double _cartSubtotal = 0.0;
  double _taxTotal = 0.0;
  double _discount = 0.0;
  DiscountModel _discountModel = DiscountModel();

  String _selectedOrderType = 'Take Away';

  all.AllProducts _allProducts = all.AllProducts();

  Map<String, dynamic> _customerData = {
    'customerName': '',
    'customerPhone': '',
    'waiterName': '',
  };

  //* GETTERS
  Categories get categories => _categories;
  int get firstSelectedCategory => _firstSelectedCategory;

  Products get selectedProductsList => _selectedProductsList;

  ProductDetails get productDetails => _productDetails;
  Variants get variants => _variant;
  List<CartLineItem> get cartItems => _cartLineItems;

  double get cartTotal => _cartTotal;
  double get cartSubtotal => _cartSubtotal;
  double get taxTotal => _taxTotal;
  double get discount => _discount;

  DiscountModel get discountModel => _discountModel;

  bool get menuItemsLoaded => _menuItemsLoaded;
  bool get menuItemsError => _menuItemsError;

  String get selectedOrderType => _selectedOrderType;

  all.AllProducts get allProducts => _allProducts;

  Map<String, dynamic> get customerData => _customerData;

  set setSelectedOrderType(String orderType) {
    _selectedOrderType = orderType;
    notifyListeners();
  }

  setDiscount(double discount) {
    _discount = discount;
    notifyListeners();
  }

  List<Map<String, dynamic>> cartList = [];

  void addToCart(CartLineItem cartItem) async {
    cartList.clear();
    //*
    // DisplayManager displayManager = DisplayManager();
    //*

    _cartLineItems.add(cartItem);

    var totalForSecondScreen = 0.0;

    for (var element in _cartLineItems) {
      totalForSecondScreen += element.priceWithTax;
    }

    for (var element in _cartLineItems) {
      if (element.isExtra == false) {
        cartList.add({
          'product_id': element.productId,
          'product_name': element.productName,
          'selected_size': element.selectedSize,
          'quantity': element.quantity,
          'price': element.priceWithTax,
          'is_extra': element.isExtra,
          'customer_note': element.customerNote,
          'description': element.description,
          'descriptionAr': element.descriptionAr,
          'has_extra': element.extras.isEmpty ? false : true,
          'discount': element.discount,
          'unit_price': element.priceUnit,
          'image': element.image,
          'orderTimeStamp': element.orderTimeStamp,
          'extra_string': element.extrasString,
          //* //*
          'cart_total': totalForSecondScreen,
        });
      }
    }

    log('cartItems ${cartList.toString()}');

    // Map<String, dynamic> data = {
    //   'bool': true,
    //   'data': jsonEncode(cartList),
    // };

    // String mapData = json.encode(data);

    // log('mapdata $mapData');

    // await displayManager.transferDataToPresentation(mapData);

    notifyListeners();
  }

  set setCustomerData(Map<String, dynamic> data) {
    _customerData = data;
    notifyListeners();
  }

  // void increaseItem(String itemId) {
  //   var chosenItem = _cartLineItems.firstWhere((item) => item.id == itemId);

  //   double singleItemPrice = chosenItem.totalPrice / chosenItem.quantity;

  //   chosenItem.quantity++;
  //   chosenItem.totalPrice += singleItemPrice;

  //   getCartTotal();
  // }

  // void decreaseItem(String itemId) {
  //   var chosenItem = _cartLineItems.firstWhere((item) => item.id == itemId);

  //   double singleItemPrice = chosenItem.totalPrice / chosenItem.quantity;

  //   if (chosenItem.quantity > 1) {
  //     chosenItem.quantity--;

  //     chosenItem.totalPrice -= singleItemPrice;
  //   }

  //   getCartTotal();
  // }

  void getCartTotal() {
    _cartTotal = 0.0;
    _cartSubtotal = 0.0;

    for (var element in _cartLineItems) {
      _cartTotal += element.priceWithTax;
      _cartSubtotal += element.priceSubtotalWithoutTax;
    }

    _taxTotal = _cartTotal - _cartSubtotal;

//    sendText('Total:\n${_cartTotal.toStringAsFixed(2)} EGP');

    notifyListeners();
  }

  Future<void> removeFromCart(String orderTimeStamp) async {
    _cartLineItems.removeWhere((element) => element.orderTimeStamp == orderTimeStamp);

    getCartTotal();

    //* //*
    //* //*
    cartList.clear();
    //*
    // DisplayManager displayManager = DisplayManager();
    //*

    var totalForSecondScreen = 0.0;

    for (var element in _cartLineItems) {
      totalForSecondScreen += element.priceWithTax;
    }

    for (var element in _cartLineItems) {
      if (element.isExtra == false) {
        cartList.add({
          'product_id': element.productId,
          'product_name': element.productName,
          'selected_size': element.selectedSize,
          'quantity': element.quantity,
          'price': element.priceWithTax,
          'is_extra': element.isExtra,
          'customer_note': element.customerNote,
          'description': element.description,
          'descriptionAr': element.descriptionAr,
          'has_extra': element.extras.isEmpty ? false : true,
          'discount': element.discount,
          'unit_price': element.priceUnit,
          'image': element.image,
          'orderTimeStamp': element.orderTimeStamp,
          'extra_string': element.extrasString,
          'cart_total': totalForSecondScreen,
        });
      }
    }

    log('cartItems ${cartList.toString()}');

    // Map<String, dynamic> data = {
    //   'bool': true,
    //   'data': jsonEncode(cartList),
    // };

    // String mapData = json.encode(data);

    // log('mapdata $mapData');

    // await displayManager.transferDataToPresentation(mapData);
  }

  void resetAfterFinishOrder(BuildContext context) async {
    //*
    // DisplayManager displayManager = DisplayManager();
    //*
    _cartLineItems = [];
    _cartTotal = 0.0;
    _cartSubtotal = 0.0;
    _taxTotal = 0.0;
    _discount = 0.0;
    _selectedOrderType = 'Take Away';

    context.read<PosProvider>().resetAfterFinishOrder();

    // sendText('Total:\n${_cartTotal.toStringAsFixed(2)} EGP');

    var emptyMap = {
      'data': [],
    };

    // await displayManager.transferDataToPresentation('{"data":[]}');

    notifyListeners();
  }

  //* //* //* //*

  Future<void> getAllCategories() async {
    _categories = (await MenuApis().getAllCategories())!;

    _categories.data!.removeWhere((category) => category.name!.toLowerCase() == 'all');

    _firstSelectedCategory = categories.data![0].id!;

    notifyListeners();
  }

  Future<void> getCategoryProducts(int categoryId) async {
    _menuItemsLoaded = false;
    _menuItemsError = false;
    notifyListeners();

    _selectedProductsList.data = [];

    try {
      _selectedProductsList = (await MenuApis().getCategoryProducts(categoryId))!;

      _menuItemsLoaded = true;

      notifyListeners();
    } catch (e) {
      _menuItemsLoaded = false;
      _menuItemsError = true;

      notifyListeners();
    }
  }

  Future<void> getProductDetails(int productId) async {
    _productDetails = (await MenuApis().getProductDetails(productId))!;

    notifyListeners();
  }

  Future<void> getVariants() async {
    _variant = (await MenuApis().getVariants())!;

    notifyListeners();
  }

  Future<void> getDiscountData() async {
    _discountModel = (await PosApis().getDiscountData())!;

    notifyListeners();
  }

  //* //*

  List<all.Datum> _searchResult = [];
  List<all.Datum> get searchResult => _searchResult;

  bool _searchlanguageIsEnglish = false;
  bool get searchLanguageIsEnglish => _searchlanguageIsEnglish;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void clearSearchList() {
    _searchResult = [];
    _isSearching = false;
    notifyListeners();
  }

  String normalizeArabic(String text) {
    if (text.isEmpty) return text;

    // Replace "أ" with "ا" only at the beginning of words
    return text.replaceAllMapped(RegExp(r'(^|\s)أ'), (match) {
      return '${match.group(1)!}ا';
    });
  }

  void onSearchTextChanged(String text) async {
    _searchResult = [];
    if (text.isNotEmpty && _allProducts.data!.isNotEmpty) {
      //* REGEXP FOR DETECTING WHICH KEYBOARD LANGAUGE THE USER IS USING
      // here this regexp only for English chars so in your case find the suitable regex for the language you want
      // RegExp exp = RegExp("[a-zA-Z]");
      RegExp expEnglish = RegExp("[a-zA-Z]");

      // simply checking if the last char is an English char and not space make the textDirection left to right
      if (expEnglish.hasMatch(text[0])) {
        _searchlanguageIsEnglish = true;
        notifyListeners();
      } else {
        _searchlanguageIsEnglish = false;
        notifyListeners();
      }
      // this line is to indicate the change of the last char in the string will print true or false
      //  print(expEnglish.hasMatch(text.substring(text.length - 1)).toString());
      //*

      _searchResult.clear();
      if (text.isEmpty) {
        return;
      }
      for (var result in _allProducts.data!) {
        String query = normalizeArabic(text);
        String nameArNormalized = normalizeArabic(result.nameAr ?? "");

        if (result.name.toString().toLowerCase().contains(text.toLowerCase()) || nameArNormalized.contains(query)) {
          _searchResult.add(result);
        }
      }

      _isSearching = true;
      notifyListeners();
    }
    //* TO HIDE THE SEARCH RESULT BOX
    if (text.isEmpty) {
      _searchResult = [];
      _isSearching = false;
      notifyListeners();
    }

    //* //* //*
    for (var element in _searchResult) {
      print('${element.nameAr} -- ${element.name}');
    }
  }

  Future<void> getAllProducts() async {
    _allProducts = (await MenuApis().getAllProducts())!;

    notifyListeners();
  }
}
