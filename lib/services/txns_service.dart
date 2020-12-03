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
        '$API_BASE_URL/api/v1/transactions?page=$page',
        headers: {'Content-Type': 'application/json', 'token': token},
      );

      Map res_data = json.decode(res.body);

      if (res.statusCode == 200) {
        _txnsList = List<TxnData>.from(
            res_data['transactions'].map((txn) => TxnData.fromJson(txn)));

        return Future.value(_txnsList);
      } else {
        return Future.error("Code: ${res.statusCode}, Error: ");
      }
    } catch (e) {
      return Future.error("Error: $e");
    }
  }
}
