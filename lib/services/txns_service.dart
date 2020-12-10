import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/utils/constants.dart';

class TxnsService {
  SharedPreferences prefs;
  String token;
  TxnData _txnData;
  List<TxnData> _txnsList = List();

  Future<List<TxnData>> getTxns({page = 1}) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    try {
      final res = await http.get(
        '$API_BASE_URL/api/v1/agents/transactions/?page=$page&limit=10',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      Map resData = json.decode(res.body);
      print('what is happening $resData');
      if (res.statusCode == 200) {
        _txnsList = List<TxnData>.from(
            resData['data'].map((txn) => TxnData.fromJson(txn)));
        // print('what is happening ${_txnsList}');
        return Future.value(_txnsList);
      } else {
        return Future.error("Code: ${res.statusCode}, Error: ");
      }
    } catch (e) {
      return Future.error("Error: $e");
    }
  }
}
