import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testingprintpos/utils/constants.dart';

class AuthService {
  SharedPreferences prefs;
  String token;

  AuthService() {
    // SharedPreferences.getInstance().then((res) {
    //   token = res.getString("token");
    // });
  }

  Future<bool> login(String phone, String password) async {
    prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post('$API_BASE_URL/api/v1/auth/agents/login',
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"mobile_number": phone, "password": password}));
      if (response.statusCode == 200) {
        // print("your responce  ${response.body}");

        Map resData = json.decode(response.body);
        // print("your responcee  $resData");
        // print("your responcee  ${resData['message']}");
        if (resData['message'] != 'success') {
          return Future.value(false);
        } else {
          String token = resData['token'];
          String message = resData['message'];
          // print("your message: $message");
          // print("Set Token: $token");
          prefs.setString("token", token);
          return Future.value(true);
        }
      } else {
        print('Failed to login');
        return Future.value(false);
      }
    } catch (e) {
      print('error occured');
      return Future.error(e);
    }
  }

  Future<bool> checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    if (token != "" && token != null) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<bool> resetPasscode(String phone) async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    final response =
        await http.get('$API_BASE_URL/api/v1/reset-password?phone=$phone');

    if (response.statusCode == 200) {
      Map res_data = json.decode(response.body);
      if (res_data['is_error']) {
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      return Future.value(false);
    }
  }

  Future<bool> authTxn(String password) async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      final response = await http.post(
          '$API_BASE_URL/api/v1/transaction/authorize',
          headers: {'Content-Type': 'application/json', 'token': token},
          body: json.encode({"password": password}));

      if (response.statusCode == 200) {
        Map res_data = json.decode(response.body);
        print(res_data);
        if (res_data['is_error']) {
          return Future.error(res_data['msg']);
        } else {
          if (res_data['authorized']) {
            return Future.value(true);
          }
          return Future.error(res_data['msg']);
        }
      } else {
        return Future.error('Error contacting server');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<bool> changePassword(
      String curPassword, String newPassword, String newPassword2) async {
    prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    try {
      final response = await http.post('$API_BASE_URL/api/v1/user/set-password',
          headers: {'Content-Type': 'application/json', 'token': token},
          body: json.encode({
            "current_password": curPassword,
            "new_password": newPassword,
            "new_password_confirm": newPassword2
          }));

      if (response.statusCode == 200) {
        Map res_data = json.decode(response.body);
        print(res_data);
        if (res_data['is_error']) {
          return Future.error(res_data['msg']);
        } else {
          return Future.value(true);
        }
      } else {
        return Future.error('Error contacting server');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
