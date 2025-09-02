import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/add_delivery_user.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/all_products.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/categories.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/generate_delivery_payment.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/product_details.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/product_tax.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/products.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/register_delivery_payment.dart';
import 'package:pos_windows_ice_hub/app/menu_cart_cycle.dart/models/variants.dart';
import 'package:pos_windows_ice_hub/services/dio_client.dart';

class MenuApis {
  static const int _maxRetries = 20;
  static const Duration _retryDelay = Duration(seconds: 1);

  /// Generic helper for retrying requests on status 500
  // Future<T?> _retryRequest<T>(Future<Response> Function() request, T Function(dynamic data) parser, {int retryCount = 0}) async {
  //   try {
  //     final response = await request();

  //     if (response.statusCode == 200) {
  //       return parser(response.data);
  //     } else if (response.statusCode == 500 && retryCount < _maxRetries) {
  //       await Future.delayed(_retryDelay);
  //       return _retryRequest(request, parser, retryCount: retryCount + 1);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     if (retryCount < _maxRetries) {
  //       await Future.delayed(_retryDelay);
  //       return _retryRequest(request, parser, retryCount: retryCount + 1);
  //     } else {
  //       throw 'API error after $_maxRetries retries >> $e';
  //     }
  //   }
  // }

  Future<T?> _retryRequest<T>(
    Future<Response> Function() request,
    T Function(dynamic data) parser, {
    int retryCount = 0,
    bool debugPrintResponse = false,
  }) async {
    try {
      final response = await request();

      if (debugPrintResponse) {
        print('API Response [${response.statusCode}]: ${response.data}');
      }

      if (response.statusCode == 200) {
        return parser(response.data);
      } else if (response.statusCode == 500 && retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _retryRequest(
          request,
          parser,
          retryCount: retryCount + 1,
          debugPrintResponse: debugPrintResponse,
        );
      } else {
        return null;
      }
    } catch (e) {
      // if using Dio, you may want to check for DioError to print response.data
      if (debugPrintResponse) {
        if (e is DioException && e.response != null) {
          print('API Error Response [${e.response?.statusCode}]: ${e.response?.data}');
        } else {
          print('API Exception: $e');
        }
      }

      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _retryRequest(
          request,
          parser,
          retryCount: retryCount + 1,
          debugPrintResponse: debugPrintResponse,
        );
      } else {
        print('API error after $_maxRetries retries >> $e');
        return null;
      }
    }
  }

  Future<Categories?> getAllCategories() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_all_categories'),
      (data) => Categories.fromJson(data),
    );
  }

  Future<Products?> getCategoryProducts(int categoryId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_category_products/$categoryId'),
      (data) => Products.fromJson(data),
    );
  }

  Future<ProductDetails?> getProductDetails(int productId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_product_details/$productId'),
      (data) => ProductDetails.fromJson(data),
    );
  }

  Future<void> uploadProfileImage(File file, int productId, BuildContext context) async {
    return _retryRequest(
      () async {
        var formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
          "product_id": productId,
        });
        return Client.client.post('http://157.180.26.238:10000/upload_product_image', data: formData);
      },
      (data) {
        print('UPLOAD IMAGE >> ${data.toString()}');
        return;
      },
    );
  }

  Future<Variants?> getVariants() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_all_variants'),
      (data) => Variants.fromJson(data),
    );
  }

  Future<ProductTax?> getProductTax(int taxId) async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_product_taxes_data/$taxId'),
      (data) => ProductTax.fromJson(data),
    );
  }

  Future<AllProducts?> getAllProducts() async {
    return _retryRequest(
      () => Client.client.get('http://157.180.26.238:10000/get_all_products'),
      (data) => AllProducts.fromJson(data),
    );
  }
}
