import 'package:flutter/material.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';
import 'package:pos_windows_ice_hub/app/open_cheque_cycle/models/open_cheque_model.dart';

class OpenChequeProvider with ChangeNotifier {
  //* VARIABLES
  bool _isOpenCheque = false;

  String _selectedTableId = '';

  OpenChequeModel _selectedCheque = OpenChequeModel(
    cartItems: [],
    id: '',
    subtotal: 0.0,
    tableName: '',
    taxes: 0.0,
    total: 0.0,
  );

  final List<OpenChequeModel> _openCheques = [];

  //* GETTERS
  bool get isOpenCheque => _isOpenCheque;

  List<OpenChequeModel> get openChequesList => _openCheques;

  String get selectedTableId => _selectedTableId;

  OpenChequeModel get selectedCheque => _selectedCheque;

  //* FUNCTIONS
  void openCheque() {
    _isOpenCheque = true;
    notifyListeners();
  }

  void closeCheque() {
    _isOpenCheque = false;
    notifyListeners();
  }

  void addOpenChequeTable(OpenChequeModel cheque) {
    _openCheques.add(cheque);
    notifyListeners();
  }

  void setSelectedTableId(String id, OpenChequeModel openCheque) {
    _selectedTableId = id;
    _selectedCheque = openCheque;
    notifyListeners();
  }

  void addItemToCart(String tableId, CartLineItem cartItem) {
    var openCheque = _openCheques.firstWhere((cheque) => cheque.id == tableId);

    openCheque.cartItems.add(cartItem);
    //*
    openCheque.total = 0.0;
    openCheque.subtotal = 0.0;

    for (var element in openCheque.cartItems) {
      openCheque.total += element.priceWithTax;
      openCheque.subtotal += element.priceSubtotalWithoutTax;
    }

    openCheque.taxes = openCheque.total - openCheque.subtotal;
    //*
    print(openCheque.total);
    print(openCheque.subtotal);
    print(openCheque.taxes);
    //*
    notifyListeners();
  }

  void changeTableName(String tableId, String newName) {
    var openCheque = _openCheques.firstWhere((cheque) => cheque.id == tableId);
    openCheque.tableName = newName;
    notifyListeners();
  }

  void deleteTable(String tableId) {
    _openCheques.removeWhere((cheque) => cheque.id == tableId);
    _selectedTableId = '';

    notifyListeners();
  }

  void resetAfterFinishOrder(String tableId) {
    var openCheque = _openCheques.firstWhere((cheque) => cheque.id == tableId);
    openCheque.cartItems.clear();
    openCheque.total = 0.0;
    openCheque.subtotal = 0.0;
    openCheque.taxes = 0.0;

    _openCheques.removeWhere((cheque) => cheque.id == tableId);
    _selectedTableId = '';

    notifyListeners();
  }
}
