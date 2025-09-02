import 'package:flutter/material.dart';
import 'package:pos_windows_ice_hub/app/auth_cycle/model/login_model.dart';
import 'package:pos_windows_ice_hub/helpers/navigation_helper.dart';
import 'package:pos_windows_ice_hub/services/dio_client.dart';

class AuthApis {
  Future<Login?> login(String email, String password, String uniqueId, BuildContext context) async {
    String url = 'http://157.180.26.238:10000/signin';

    print('''
"email": $email, "password": $password, "unique_id": $uniqueId
''');

    try {
      final response = await Client.client.post(
        url,
        data: {"email": email, "password": password, "unique_id": uniqueId.toLowerCase()},
        // data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        print(response.data.toString());

        Login login = Login.fromJson(response.data);
        return login;
      } else {
        return null;
      }
    } catch (e) {
      throw 'login error >> $e';
    } finally {
      Navigation().closeDialog(context);
    }
  }
}
