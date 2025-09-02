// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/add_delivery_user.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/all_products.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/categories.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/generate_delivery_payment.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/product_details.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/product_tax.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/products.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/register_delivery_payment.dart';
// import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/variants.dart';
// import 'package:pos_windows_ice_hub/services/dio_client.dart';

// class MenuApis {
//   Future<Categories?> getAllCategories() async {
//     String url = 'http://157.180.26.238:10000/get_all_categories';
//     print(url);

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         Categories categories = Categories.fromJson(response.data);

//         return categories;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getAllCategories error >> $e';
//     }
//   }

//   Future<Products?> getCategoryProducts(int categoryId) async {
//     String url = 'http://157.180.26.238:10000/get_category_products/$categoryId';
//     print(url);

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         Products products = Products.fromJson(response.data);
//         return products;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getCategoryProducts error >> $e';
//     }
//   }

//   Future<ProductDetails?> getProductDetails(int productId) async {
//     String url = 'http://157.180.26.238:10000/get_product_details/$productId';

//     print(url);

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         ProductDetails productDetails = ProductDetails.fromJson(response.data);
//         return productDetails;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getProductDetails error >> $e';
//     }
//   }

//   Future<void> uploadProfileImage(File file, int productId, BuildContext context) async {
//     String url = 'http://157.180.26.238:10000/upload_product_image';

//     try {
//       var formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
//         "product_id": productId,
//       });

//       final response = await Client.client.post(url, data: formData);

//       if (response.statusCode == 200) {
//         print('UPLOAD IMAGE >> ${response.data.toString()}');
//       }
//     } catch (e) {
//       throw ('uploadProductPicture >> $e');
//     }
//   }

//   Future<Variants?> getVariants() async {
//     String url = 'http://157.180.26.238:10000/get_all_variants';

//     try {
//       final response = await Client.client.get(url);

//       if (response.statusCode == 200) {
//         Variants variants = Variants.fromJson(response.data);
//         return variants;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getVariants error >> $e';
//     }
//   }

//   Future<ProductTax?> getProductTax(int taxId) async {
//     String url = 'http://157.180.26.238:10000/get_product_taxes_data/$taxId';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         ProductTax productTax = ProductTax.fromJson(response.data);
//         return productTax;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getProductTax error >> $e';
//     }
//   }

//   Future<AllProducts?> getAllProducts() async {
//     String url = 'http://157.180.26.238:10000/get_all_products';

//     try {
//       final response = await Client.client.get(url);
//       if (response.statusCode == 200) {
//         AllProducts allProducts = AllProducts.fromJson(response.data);
//         return allProducts;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw 'getAllProducts error >> $e';
//     }
//   }
// }
