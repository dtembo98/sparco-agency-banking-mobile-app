import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/utils/constants.dart';

class TxnService {
  SharedPreferences prefs;
  String token;
  TxnData _txnData;

  Future<TxnData> processTxn(String service, String msisdn, double amount,
      {String ref = "",
      String meterNumber = "",
      @required String pathName}) async {
    // Hive.openBox('txnData');
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // TxnData ds = {'amount': _txnData.amount} as TxnData;
    print(pathName);
    try {
      final res = await http.post(
          '$API_BASE_URL/api/v1/agents/transactions/$pathName',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            "service": service,
            "msisdn": msisdn,
            "amount": amount,
            "ref": ref,
            "meter_number": meterNumber,
          }));
      Map resData = json.decode(res.body);

      print(' checking responce  ${resData}');
      print('checking status ${res.statusCode}');
      if (res.statusCode == 200) {
        _txnData = TxnData.fromJson(resData);

        // Hive.box('txnData').add(_txnData);

        print(" transactions made now ${resData}");

        return Future.value(_txnData);
      } else if (resData['is_error']) {
        print('${res.statusCode}');
        // Map resData = json.decode(res.body);
        print('Failed to load');
        _txnData = TxnData(isError: true);
        // Hive.box('txnData').add(_txnData);
        // print('error  happend ${_txnData}');
        return Future.value(_txnData);
      }
    } catch (e) {
      print(e);
      _txnData = TxnData(isError: true);
      // Hive.box('txnData').add(_txnData);
      print('exception $_txnData');
      return Future.value(_txnData);
    }
  }

  Future<TxnData> getTxn(int txnId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    try {
      final res = await http.get(
        '$API_BASE_URL/api/v1/agents/transactions/$txnId',
        headers: {'Content-Type': 'application/json', 'token': token},
      );

      if (res.statusCode == 200) {
        Map resData = json.decode(res.body);
        print(' hil am loging from gettxn$resData');
        // Hive.box('txnData').add(resData);
        if (resData['is_error']) {
          _txnData = TxnData(isError: true);

          return Future.value(_txnData);
        } else {
          _txnData = TxnData.fromJson(resData);
          return Future.value(_txnData);
        }
      } else {
        _txnData = TxnData(isError: true);
        return Future.value(_txnData);
      }
    } catch (e) {
      _txnData = TxnData(isError: true);
      return Future.value(_txnData);
    }
  }
}
