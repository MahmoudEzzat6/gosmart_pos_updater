import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class Odoo {
  Future<OdooSession?> initOdooConnection(String email, String password) async {
    try {
      //final client = OdooClient('https://pos.gosmart.eg/web/login?db=pos');
      final client = OdooClient('https://pos-c1.gosmart.eg/web/login?db=ice_cream_hub_sheraton');

      await client.authenticate('ice_cream_hub_sheraton', email, password);
      final res = await client.callRPC('/web/session/modules', 'call', {});

      var odooClient = client;
      OdooSession odooSession = odooClient.sessionId!;

      log('sessionId: ${odooClient.sessionId!}');

      return odooSession;
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
      throw ('initOdooConnection error > $e');
    }
  }
}
