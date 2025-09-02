import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/model/login_model.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/services/auth_apis.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_kiosk_orders.dart'
    as allkiosk;
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_pos.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_session_orders.dart'
    as allsessionorders;
import 'package:pos_windows_ice_hub/app/pos_cycle/models/all_users.dart' as du;
import 'package:pos_windows_ice_hub/app/pos_cycle/models/available_payment_methods.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/current_session.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/open_pos_session.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/models/pos_sessions.dart'
    as ps;
import 'package:pos_windows_ice_hub/app/pos_cycle/models/search_by_receipt.dart'
    as refundorder;
import 'package:pos_windows_ice_hub/app/pos_cycle/models/status_msg_model.dart';
import 'package:pos_windows_ice_hub/app/pos_cycle/services/pos_apis.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/main.dart';
import 'package:pos_windows_ice_hub/widget/unclosable_ok_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;

import 'package:connectivity_plus/connectivity_plus.dart';

class PosProvider with ChangeNotifier {
  bool _connectState = true;

  int _loadingPercentage = 0;

  Login _loginData = Login();

  AllPos _allPos = AllPos();

  int _customerId = 0;
  int get customerId => _customerId;
  set setCustomerId(int value) {
    _customerId = value;
    notifyListeners();
  }

  int _adminId = 0;
  int get adminId => _adminId;
  set setAdminId(int value) {
    _adminId = value;
    notifyListeners();
  }

  int _unFinishedReceiptOrders = 0;
  int get unFinishedReceiptOrders => _unFinishedReceiptOrders;
  set setUnFinishedReceiptOrders(int value) {
    _unFinishedReceiptOrders = value;
    notifyListeners();
  }

  //* //* SEARCH
  bool get connectState => _connectState;
  ps.PosSessions _posSessions = ps.PosSessions();
  bool _isSearchingSessions = false;
  List<ps.Datum> _allSessionsSearchResult = [];

  OpenPosSession _openPosSession = OpenPosSession();

  CurrentSession _currentSession = CurrentSession();

  AvailablePaymentMethods _availablePaymentMethods = AvailablePaymentMethods();
  int _selectedPaymentMethodId = 0;
  String _selectedPaymentMethodName = '';

  du.DeliveryUsers _deliveryUsers = du.DeliveryUsers(data: [], status: 0);
  bool _isDeliveryOrder = false;

  //* //* SEARCH SESSION ORDERS
  allsessionorders.AllSessionOrders _allSessionOrders =
      allsessionorders.AllSessionOrders();
  List<allsessionorders.Datum> _allOrdersSearchResults = [];
  bool _isSearching = false;

  allkiosk.AllKioskOrders _allKioskOrders = allkiosk.AllKioskOrders();
  List<allkiosk.OrderLine> _kioskOrdersList = [];
  double _kioskOrderTotal = 0.0;

  String _latestOrderRefrence = '';
  String _latestOrderNumber = '';

  bool _discountApplied = false;
  bool _promotionApplied = false;

  bool get discountApplied => _discountApplied;
  bool get promotionApplied => _promotionApplied;

//* MARIAM
  Future<bool> isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _connectState = false;
      return _connectState;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _connectState = true;
        return _connectState;
      }
      _connectState = false;
      return _connectState;
    } catch (e) {
      _connectState = false;
      return _connectState;
    }
  }

  set setDiscountApplied(bool value) {
    _discountApplied = value;
    notifyListeners();
  }

  set setPromotionApplied(bool value) {
    _promotionApplied = value;
    notifyListeners();
  }

  String get latestOrderRefrence => _latestOrderRefrence;
  String get latestOrderNumber => _latestOrderNumber;

  set setLatestOrderRefrence(String value) {
    _latestOrderRefrence = value;
    notifyListeners();
  }

  set setLatestOrderNumber(String value) {
    _latestOrderNumber = value;
    notifyListeners();
  }

  //* FOR REFUND
  refundorder.Datum _refundOrderDetails = refundorder.Datum();

  //* USB PRINTER
  bool _usePrinter = true;
  bool get usePrinter => _usePrinter;
  set setUsePrinter(bool value) {
    _usePrinter = value;
    notifyListeners();
  }

  bool _isUSBPrinter = false;
  late PrinterManager _printerManagerUSB; //*mariam
  int _vendorId = -1;
  int _productId = -1;

  //* //*
  bool get isUSBPrinter => _isUSBPrinter;
  PrinterManager get printerManagerUSB => _printerManagerUSB; //*mariam
  int get vendorId => _vendorId;
  int get productId => _productId;

  //*mariam
  set setPrinterManagerUSB(PrinterManager value) {
    _printerManagerUSB = value;
    notifyListeners();
  }

//*mariam
  String _printName = '';
  String get printName => _printName;

  set setVendorId(int value) {
    _vendorId = value;
    notifyListeners();
  }

  set setProductId(int value) {
    _productId = value;
    notifyListeners();
  }

  set setIsUSBPrinter(bool value) {
    _isUSBPrinter = value;
    notifyListeners();
  }

  //* GETTERS

  int get loadingPercentage => _loadingPercentage;

  AllPos get allPos => _allPos;

  ps.PosSessions get posSessions => _posSessions;
  bool get isSearchingSessions => _isSearchingSessions;
  List<ps.Datum> get allSessionsSearchResult => _allSessionsSearchResult;

  OpenPosSession get openPosSession => _openPosSession;

  Login get loginData => _loginData;

  CurrentSession get currentSession => _currentSession;

  AvailablePaymentMethods get availablePaymentMethods =>
      _availablePaymentMethods;
  int get selectedPaymentMethodId => _selectedPaymentMethodId;
  String get selectedPaymentMethodName => _selectedPaymentMethodName;

  du.DeliveryUsers get deliveryUsers => _deliveryUsers;
  bool get isDeliveryOrder => _isDeliveryOrder;

  allsessionorders.AllSessionOrders get allSessionOrders => _allSessionOrders;
  List<allsessionorders.Datum> get allOrdersSearchResults =>
      _allOrdersSearchResults;
  bool get isSearching => _isSearching;

  set setIsSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  allkiosk.AllKioskOrders get allKioskOrders => _allKioskOrders;
  List<allkiosk.OrderLine> get kioskOrdersList => _kioskOrdersList;
  double get kioskOrderTotal => _kioskOrderTotal;

  set setKioskOrdersList(List<allkiosk.OrderLine> value) {
    _kioskOrdersList = value;
    notifyListeners();
  }

  set setKioskOrderTotal(double value) {
    _kioskOrderTotal = value;
    notifyListeners();
  }

  refundorder.Datum get refundOrderDetails => _refundOrderDetails;

  //* SETTERS

  set setRefundOrderDetails(refundorder.Datum value) {
    _refundOrderDetails = value;
    notifyListeners();
  }

  set setLoadingPercentage(int value) {
    _loadingPercentage = value;
    notifyListeners();
  }

  Future<void> getAllPos() async {
    _allPos = (await PosApis().getAllPos())!;

    notifyListeners();
  }

  Future<void> getPosSessions(int posId) async {
    _posSessions = (await PosApis().getPosSessions(posId))!;

    notifyListeners();
  }

  Future<StatusMsgModel?> archivePos(int posId) async {
    StatusMsgModel? statusMsgModel = await PosApis().archivePOS(posId);
    await getAllPos();

    return statusMsgModel;
  }

  Future<void> addNewPos(String posName) async {
    await PosApis().addNewPos(posName);

    getAllPos();
  }

  Future<void> openNewPosSession(int posId, int cashierId, int currencyId,
      double openingBalance, String openingNote) async {
    _openPosSession = (await PosApis().openNewPosSession(
        posId, cashierId, currencyId, openingBalance, openingNote))!;

    await getCurrentSessionData(posId);

    //  notifyListeners();
  }

  set setLoginData(Login value) {
    _loginData = value;
    notifyListeners();
  }

  // Future<void> login(String email, String password, String deviceId) async {
  //   _loginData = (await AuthApis().login(email, password, deviceId))!;

  //   notifyListeners();
  // }

  Future<Map<String, dynamic>> checkForActiveSessions(
      int posId, int cashierId) async {
    // Future<bool> checkForActiveSessions(int posId, int cashierId) async {
    await getPosSessions(posId);

    //* Check for first time for this POS

    if (_posSessions.status == 0 && _posSessions.data!.isEmpty) {
      //* this is the first use for this pos

      print('FIRST TIME USE POS');

      return {"has_active_session": false, "same_user": true};
    }
    //* //*
    else {
      if (_posSessions.data![0].state == 'Opened/Active' &&
          _posSessions.data![0].cashierId == cashierId) {
        print('POS HAS ACTIVE SESSION WITH SAME USER');
        return {"has_active_session": true, "same_user": true};
      } else if (_posSessions.data![0].state == 'Opened/Active' &&
          _posSessions.data![0].cashierId != cashierId) {
        print('POS DOES NOT HAS ACTIVE SESSION WITH DIFF USER');
        return {"has_active_session": true, "same_user": false};
      } else {
        return {"has_active_session": false, "same_user": false};
      }
    }
  }

  Future<void> getCurrentSessionData(int posId) async {
    _currentSession = (await PosApis().getCurrentSessionData(posId))!;

    if (_currentSession.status != 0) {
      print('CURRENT SESSION ID: ${_currentSession.data![0].id!}');
    }

    notifyListeners();
  }

  Future<void> getAvailablePaymentMethods() async {
    _availablePaymentMethods = (await PosApis().getAvailablePaymentMethods())!;

    _availablePaymentMethods.data!.removeWhere(
        (element) => element.posId != posId && element.posId != -1);

    print(_availablePaymentMethods.data.toString());

    notifyListeners();
  }

  void setSelectedPaymentMethod(int paymentMethodId, String paymentMethodName) {
    _selectedPaymentMethodId = paymentMethodId;
    _selectedPaymentMethodName = paymentMethodName;

    notifyListeners();
  }

  Future<void> getDeliveryUsers(String phoneNumber) async {
    _deliveryUsers = (await PosApis().getDeliveryUserByNumber(phoneNumber))!;

    notifyListeners();
  }

  Future<void> addNewDeliveryUser(
      String name, String phone, String address) async {
    _deliveryUsers.data!.clear();

    await PosApis().addDeliveryUser(name, phone, address).then((value) {
      if (value!.status == 1) {
        _deliveryUsers.data!.add(du.Datum(
          address: address,
          id: value.resDeliveryId,
          name: name,
          phone: phone,
        ));
      }
    });

    _isDeliveryOrder = true;

    notifyListeners();
  }

  set setIsDeliveryOrder(bool value) {
    _isDeliveryOrder = value;
    notifyListeners();
  }

  void resetAfterFinishOrder() {
    _isDeliveryOrder = false;
    _deliveryUsers = du.DeliveryUsers(data: [], status: 0);
    _selectedPaymentMethodId = 0;
    _selectedPaymentMethodName = '';

    _discountApplied = false;
    _promotionApplied = false;

    notifyListeners();
  }

  Future<void> getAllSessionOrders(int sessionId) async {
    _allSessionOrders = (await PosApis().getAllSessionOrders(sessionId))!;

    _unFinishedReceiptOrders = _allSessionOrders.data!
        .where((order) => order.invoiceDetails!.isEmpty)
        .length;

    notifyListeners();
  }

  Future<void> generateAndRegisterDeliveryOrder(
      int orderId, int journalId, int sessionId) async {
    await PosApis().generateAndRegisterDeliveryOrder(orderId, journalId);
    await getAllSessionOrders(sessionId);
  }

  Future<void> refundOrder(
      int adminId,
      int orderId,
      int posId,
      bool currentPosActiveSessionState,
      int currentPosActiveSessionId,
      BuildContext context) async {
    //* FIRST CHECK FOR ACTIVE SESSION
    if (currentPosActiveSessionState == false) {
      print('SESSION CLOSED REFUND');
      //* CLOSED THEN OPEN SESSION > REFUND > CLOSE SESSION

      await PosApis()
          .openNewPosSession(posId, adminId, currencyId, 0.0, 'refund')
          .then((openSession) async {
        if (openSession!.status == 1) {
//*
          await PosApis().draftRefundOrderFirst(orderId).then((first) async {
            if (first!.status == 1) {
              await PosApis()
                  .refundOrderPaymentSecond(
                      posId, openSession.sessionId!, first.refundOrderId!)
                  .then((second) async {
                if (second!.status == 1) {
                  await PosApis()
                      .reverseRefundOrderInvoiceThird(
                          posId, openSession.sessionId!, first.refundOrderId!)
                      .then((third) async {
                    //*
                    await PosApis()
                        .closeSession(openSession.sessionId!, 0.0, 'refund');
                    //*
                    showDialog(
                        context: context,
                        builder: (context) => UnClosableOkDialog(
                            text: third!.messageAr!,
                            onPressed: () {
                              Navigation().closeDialog(context);
                              Navigation().closeDialog(context);
                              Navigation().closeDialog(context);
                              Navigation().closeDialog(context);
                              Navigation().closeDialog(context);
                            }));
                  });
                }
              });
            }
          });
//*
        }
      });
    } else {
      await PosApis().draftRefundOrderFirst(orderId).then((first) async {
        if (first!.status == 1) {
          await PosApis()
              .refundOrderPaymentSecond(
                  posId, currentPosActiveSessionId, first.refundOrderId!)
              .then((second) async {
            if (second!.status == 1) {
              await PosApis()
                  .reverseRefundOrderInvoiceThird(
                      posId, currentPosActiveSessionId, first.refundOrderId!)
                  .then((third) {
                //*
                showDialog(
                    context: context,
                    builder: (context) => UnClosableOkDialog(
                        text: third!.messageAr!,
                        onPressed: () {
                          Navigation().closeDialog(context);
                          Navigation().closeDialog(context);
                          Navigation().closeDialog(context);
                          Navigation().closeDialog(context);
                          Navigation().closeDialog(context);
                        }));
              });
            }
          });
        }
      });
    }
  }

  //* //* SEARCH ALL ORDERS

  void clearSearchAllOrdersList() {
    _allOrdersSearchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  void onSearchAllOrdersTextChanged(String text) async {
    _allOrdersSearchResults = [];
    if (text.isNotEmpty && _allSessionOrders.data!.isNotEmpty) {
      _allOrdersSearchResults.clear();
      if (text.isEmpty) {
        return;
      }
      for (var result in _allSessionOrders.data!) {
        if (result.posReference
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase())) {
          _allOrdersSearchResults.add(result);
        }
      }

      _isSearching = true;
      notifyListeners();
    }
    //* TO HIDE THE SEARCH RESULT BOX
    if (text.isEmpty) {
      _allOrdersSearchResults = [];
      _isSearching = false;
      notifyListeners();
    }
  }
  //* //*

  //* SEARCH ALL SESSIONS

  void clearSearchAllSessionsList() {
    _allSessionsSearchResult = [];
    _isSearchingSessions = false;
    notifyListeners();
  }

  void onSearchAllSessionsTextChanged(String text) async {
    _allSessionsSearchResult = [];
    if (text.isNotEmpty && _posSessions.data!.isNotEmpty) {
      _allSessionsSearchResult.clear();
      if (text.isEmpty) {
        return;
      }
      for (var result in _posSessions.data!) {
        if (result.name.toString().toLowerCase().contains(text.toLowerCase()) ||
            result.cashierName
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            result.posName
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase())) {
          _allSessionsSearchResult.add(result);
        }
      }

      _isSearching = true;
      notifyListeners();
    }
    //* TO HIDE THE SEARCH RESULT BOX
    if (text.isEmpty) {
      _allSessionsSearchResult = [];
      _isSearching = false;
      notifyListeners();
    }
  }

  //*//*//*//* mariam
  set setPrintName(String value) {
    _printName = value;
    notifyListeners();
  }

  //*//*//*//* mariam
  void updateUSBPrinter({
    required PrinterManager printerManager,
    required String printName,
    required int vendorId,
    required int productId,
  }) {
    _printerManagerUSB = printerManager;
    notifyListeners();
    setPrintName = printName;
    notifyListeners();
    setVendorId = vendorId;
    notifyListeners();
    _productId = productId;
    notifyListeners();
    _isUSBPrinter = true;
    notifyListeners();
    log("✅ Updated printer: vendor=$_vendorId, product=$_productId");
  }

  //* /mariam
  Future printReceipt(
      ScreenshotController screenshotController, bool isUSB) async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');
    //*

    // var logoFromAssets = await rootBundle.load('assets/images/ice_logo2.png');

    //var logo = logoFromAssets.buffer.asUint8List();

    final capturedImage = await screenshotController.capture(
      delay: const Duration(milliseconds: 20),
      pixelRatio: 1.5,
    );

    // log(capturedImage.toString());

    img.Image? decodedImage = img.decodeImage(capturedImage!);
    // img.Image? decodedLogo = img.decodeImage(logo);

    //* TITLE LOGO
    // bytes += generator.image(decodedLogo!, align: PosAlign.center, isDoubleDensity: true);

    // bytes += generator.text('------------------------------------------------',
    //     styles: const PosStyles(
    //       bold: true,
    //       fontType: PosFontType.fontA,
    //       height: PosTextSize.size1,
    //     ));

    bytes += generator.image(decodedImage!,
        align: PosAlign.center, isDoubleDensity: true);

    //* //*

    // bytes += generator.cut();
    //*

    log('isUSB >> $_isUSBPrinter');

    if (_isUSBPrinter) {
      _printEscPosUSB(bytes, generator);
    }
    // else {
    //   _printEscPosWIFI(bytes, generator);
    // }
  }

  List<int>? pendingTask;

  /// print ticket USB
  //*mariam
  void _printEscPosUSB(List<int> bytes, Generator generator) async {
    final printerInput = UsbPrinterInput(
      name: _printName,
      vendorId: _vendorId.toString(),
      productId: _productId.toString(),
    );

    try {
      await _printerManagerUSB.connect(
        type: PrinterType.usb,
        model: printerInput,
      );

      bytes += generator.cut();

      await _printerManagerUSB.send(bytes: bytes, type: PrinterType.usb);
      await _printerManagerUSB.disconnect(type: PrinterType.usb);
    } catch (e) {
      log('USB Print Error: $e');
    }
  }

  Future<void> getAllKioskOrders(int sessionId) async {
    _allKioskOrders = (await PosApis().getAllKioskOrders(sessionId))!;
    notifyListeners();
  }

  Future<void> processKioskOrder(int orderId, int sessionId) async {
    await PosApis().processKioskOrder(orderId);
    await getAllKioskOrders(sessionId);
  }

  void sortAllSessionOrders(
      {required String filterChoice, required bool sortUp}) {
    print('filterChoice: $filterChoice');

    if (filterChoice == 'price'.tr()) {
      _allSessionOrders.data!.sort((a, b) {
        if (!sortUp) {
          return a.amountPaid!.compareTo(b.amountPaid!);
        } else {
          return b.amountPaid!.compareTo(a.amountPaid!);
        }
      });
    }

    if (filterChoice == 'date'.tr()) {
      _allSessionOrders.data!.sort((a, b) {
        if (!sortUp) {
          return a.dateOrder!.compareTo(b.dateOrder!);
        } else {
          return b.dateOrder!.compareTo(a.dateOrder!);
        }
      });
    }

    notifyListeners();
  }

  bool isUSBPrinterConnected = false;

  void setUSBPrinterConnected(bool value) {
    isUSBPrinterConnected = value;
    notifyListeners();
  }

  Future<void> checkPrinterConnection() async {
    List<PrinterDevice> devices = [];
    PrinterManager printerManager = PrinterManager.instance;
    PrinterDevice? selectedDevice;
    if (printName.isEmpty) {
      setUSBPrinterConnected(false);
      return;
    }

    try {
      // Try to connect briefly to check if printer is available
      await printerManager.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: printName,
          vendorId: selectedDevice!.vendorId,
          productId: selectedDevice.productId,
        ),
      );
      await printerManager.disconnect(type: PrinterType.usb);
      setUSBPrinterConnected(true);
    } catch (e) {
      setUSBPrinterConnected(false);
      print("⚠️ Printer disconnected: $e");
    }
  }
}
