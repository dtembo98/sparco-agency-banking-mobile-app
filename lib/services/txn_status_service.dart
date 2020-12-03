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

  TxnStatusService(int txnId) {
    Timer.periodic(Duration(seconds: 1), (t) {
      _fetchData(txnId).then((txnData) {
        if (!_controller.isClosed) {
          _controller.sink.add(txnData);
        }
      });

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
      final res = await http.get('$API_BASE_URL/api/v1/transaction?id=$txnId',
          headers: {'Content-Type': 'application/json', 'token': token});
      if (res.statusCode == 200) {
        Map res_data = json.decode(res.body);
        if (res_data['is_error']) {
          _txnData = TxnData(isError: true, msg: "Unable to get data");
          return Future.value(_txnData);
        } else {
          _txnData = TxnData.fromJson(res_data['transaction']);
          return Future.value(_txnData);
        }
      } else {
        _txnData = TxnData(isError: true, msg: "Unable to get data");
        return Future.value(_txnData);
      }
    } catch (e) {
      _txnData = TxnData(isError: true, msg: "Unable to get data");
      return Future.value(_txnData);
    }
  }
}
