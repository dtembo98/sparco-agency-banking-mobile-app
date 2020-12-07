import 'dart:convert';
import 'package:testingprintpos/models/user_data.dart';
import 'package:testingprintpos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  UserData _userData;

  Future<UserData> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // print(token);
    return (await http.get(
      '$API_BASE_URL/api/v1/agents',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((res) {
      // print(res.body);
      var resData = json.decode(res.body);
      _userData = UserData.fromJson(resData);
      print(_userData);
      return Future.value(_userData);
    }).catchError((onError) {
      print(' kjskjksjd ${onError.toString()}');
      return UserData(isError: true);
    }));
    // return Future.value(userData);
  }

  // Future<UserData> getUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // try {
  //   //   final response = await http.get(
  //   //     '$API_BASE_URL/api/v1/agents',
  //   //     headers: {
  //   //       'Content-Type': 'application/json',
  //   //       'token': prefs.getString('token')
  //   //     },
  //   //   );
  //   //   var resData = json.decode(response.body);
  //   //   print(resData);
  //   //   _userData = UserData.fromJson(resData);
  //   //   if (response.statusCode == 200) {
  //   //     if (resData['is_error']) {
  //   //       return Future.value(_userData);
  //   //     } else {
  //   //       // print('Error');
  //   //       // print(res_data);

  //   //       return Future.value(_userData);
  //   //     }
  //   //   } else {
  //   //     print('Error Loading User Data');
  //   //     print(resData);
  //   //     print(_userData);
  //   //     return Future.value(_userData);
  //   //   }
  //   // } catch (e) {
  //   //   return Future.error("Error getting user data");
  //   // }
  // }
}
