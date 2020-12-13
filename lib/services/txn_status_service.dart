import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/utils/constants.dart';

class TxnStatusService {
  final StreamController _controller = StreamController<TxnData>();
  SharedPreferences prefs;
  String token;
  TxnData _txnData;

  TxnStatusService(dynamic txnId) {
    Timer.periodic(Duration(seconds: 1), (t) {
      _fetchData(txnId).then((txnData) {
        print('testing one two ${txnData.status}');
        if (!_controller.isClosed) {
          _controller.sink.add(txnData);
        }
      });
      print(txnId);
      print("Tick ${t.tick}");

      if (t.tick == 50) {
        t.cancel();
        _controller.sink.close();
      }
    });
  }

  Stream<TxnData> get stream => _controller.stream;

  Future<TxnData> _fetchData(int txnId) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    try {
      final res = await http
          .get('$API_BASE_URL/api/v1/agents/transactions/$txnId', headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

      if (res.statusCode == 200) {
        Map resData = json.decode(res.body);
        print('fetching transaction ${resData['data']}');
        // if (resData['is_error']) {
        //   _txnData = TxnData(isError: true, msg: "Unable to get data");
        //   print(_txnData);
        //   return Future.value(_txnData);
        // } else
        if (resData['message'] == "success") {
          _txnData = TxnData.fromJson(resData['data']);

          return Future.value(_txnData);
        }
      } else {
        _txnData = TxnData(isError: true, msg: "Unable to get data");
        print(_txnData);

        return Future.value(_txnData);
      }
    } catch (e) {
      _txnData = TxnData(isError: true, msg: "Unable to get data");
      print(_txnData);
      return Future.value(_txnData);
    }
  }
}
