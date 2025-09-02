import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/cart_item.dart';

class OpenChequeModel {
  String id;
  String tableName;
  List<CartLineItem> cartItems;
  double subtotal;
  double taxes;
  double total;

  OpenChequeModel({
    required this.id,
    required this.tableName,
    required this.cartItems,
    required this.subtotal,
    required this.taxes,
    required this.total,
  });
}
