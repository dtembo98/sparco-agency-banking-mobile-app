import 'dart:async';

import 'package:intl/intl.dart';
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/screens/widgets/authorize_txn_widget.dart';
import 'package:testingprintpos/services/txn_service.dart';
import 'package:testingprintpos/services/user_service.dart';
import 'package:testingprintpos/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopUpPage extends StatefulWidget {
  final String topUpType;
  const TopUpPage({Key key, this.topUpType}) : super(key: key);
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  static const platform = const MethodChannel('samples.flutter.dev/battery');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _recipientInputController = TextEditingController();
  TextEditingController _amountInputController = TextEditingController();
  TextEditingController _meterNumberInputController = TextEditingController();
  bool _isLoading = false;
  bool _txnSucceeded = true;
  String statusMsg = "";
  TxnService _txnService = TxnService();
  int _txnId;
  StreamSubscription txnStatusSub;
  String _statusMsg = "";
  String _pageTitle;

  String _topUpType;
  String _recipientsLabelText;
  String _recipientsText;
  final UserService _userService = UserService();
  String _topUpAmount;
  Map<String, dynamic> receiptData;
  void _processTxn(String txnType, {@required String pathName}) async {
    String msisdn = _recipientInputController.text;
    double amount = double.parse(_amountInputController.text);
    String meterNumber = _meterNumberInputController.text;

    setState(() {
      _isLoading = true;
      _statusMsg = "";
    });

    TxnData _txnData = await _txnService.processTxn(txnType, msisdn, amount,
        ref: "", meterNumber: meterNumber, pathName: pathName);

    String txnStatus = _txnData.status;
    // var _txnDatails = <String, dynamic>{
    //   'token':_txnData.token,
    //   ''
    // };
    print('zezeze ${_txnData.status}');
    if (_txnData.status == 'TXN_UNSUCCESFULL') {
      _statusMsg = 'TopUp Failed';
      _txnSucceeded = false;
    }
    if (_txnData.status) {
      _statusMsg = 'TopUp Failed try again';
      _txnSucceeded = false;
    }

    if (_txnData.status == 'TXN_SUCCESSFUL') {
      _statusMsg = 'TopUp was successful';
      // final datas = await Future.value(_txnData);
      // String txntoken = _txnData.token;
      DateTime now = DateTime.now();
      // String formatedDate = DateFormat('d/M/yy H:m').format(now);
      // Map<String, dynamic> receiptData = {
      //   'agent': 'uncle vin',
      //   'receipient': '0977322133',
      //   'token': '4239 0934 7277 8436 7287',
      //   'meter': '74000387261',
      //   'amount': "k2",
      //   'units': "Khw 2.0",
      //   'txnDate': '${now.day}/${now.month}/${now.year}',
      //   'txnTime': ' ${now.hour}:${now.minute} '
      // };
      setState(() {
        receiptData = {
          'agent': '${_txnData.customerName}',
          'receipient': '${_txnData.recipient}',
          'token': '${_txnData.token}',
          'meter': '${_txnData.meterNumber}',
          'amount': '${_txnData.amount}',
          'units': "${_txnData.amount}",
          'txnDate': '${now.day}/${now.month}/${now.year}',
          'txnTime': ' ${now.hour}:${now.minute}',
          // 'customerName': '${_txnData.customerName}'
          // 'customerName': '${_txnData.amount}'
          // 'token': _txnData.token,
          // 'amount': _txnData.amount,
          // // 'txnDateTime': _txnData.txnDateTime,
          // // 'meterNumber': _txnData.desc,
          // 'recipient': _txnData.recipient,
        };
      });
      // print("your data $receiptData");
      print("your meter ${_txnData.meterNumber}");
      print("your token ${_txnData.token}");
      print("your amount ${_txnData.amount}");
      print("your serviceProviderRef ${_txnData.serviceProviderRef}");
      print("your msg ${_txnData.msg}");
      print("your recipient ${_txnData.recipient}");
      print("your sender ${_txnData.sender}");
      print("your service  ${_txnData.service}");
      print("your service  ${_txnData.customerName}");
    }

    setState(() {
      _isLoading = false;
      _statusMsg = _statusMsg;
      _txnId = _txnData.txnId;
      _txnSucceeded = _txnSucceeded;
    });
  }

  void _clearInputFields() {
    _recipientInputController.clear();
    _amountInputController.clear();
    setState(() {
      _statusMsg = "";
      _txnId = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _topUpType = widget.topUpType;

    if (_topUpType == 'airtime') {
      _recipientsLabelText = "Recipient's Phone Number";
      _pageTitle = 'Airtime';
    }

    if (_topUpType == 'electricity') {
      _recipientsLabelText = "Recipient's Phone Number";
      _pageTitle = 'Zesco';
    }

    if (_topUpType == 'data') {
      _recipientsLabelText = "Recipient's Number";
    }

    if (_topUpType == 'tv') {
      _recipientsLabelText = "DSTV Number";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("$_pageTitle TopUp"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(
          children: <Widget>[
            (_topUpType == 'electricity')
                ? TextField(
                    controller: _meterNumberInputController,
                    decoration: InputDecoration(
                        labelText: 'Zesco Meter Number',
                        hintText: "Enter Zesco Meter Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {},
                  )
                : Container(),
            SizedBox(height: 10),
            TextField(
              controller: _recipientInputController..text = _recipientsText,
              decoration: InputDecoration(
                  labelText: _recipientsLabelText,
                  hintText: "Enter $_recipientsLabelText",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              keyboardType: TextInputType.number,
              onChanged: (val) {},
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountInputController..text = _topUpAmount,
              decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter Amount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                // print(val);
              },
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Text(
              _statusMsg,
              textAlign: TextAlign.center,
            ),
            (_isLoading)
                ? Center(child: CircularProgressIndicator())
                : (_txnId != null)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            // opacity: _txnSucceeded ? 0 : 1,
                            child: _txnSucceeded
                                ? RaisedButton(
                                    onPressed: _printData,
                                    child: Text("print receipt"),
                                  )
                                : RaisedButton(
                                    child: Text("Try Again"),
                                    onPressed: () {
                                      //  _clearInputFields();
                                      _processTxn(_topUpType,
                                          pathName: 'airtime');
                                    }),
                          ),
                          RaisedButton(
                              child: Text("Perform Another TopUp"),
                              // icon: Icon(Icons.refresh),
                              onPressed: () {
                                _clearInputFields();
                              }),
                        ],
                      )
                    : RaisedButton(
                        child: Text("TopUp"),
                        onPressed: () {
                          String snackBarMsg = "";

                          if ((_topUpType == "airtime") &
                              _recipientInputController.text.isEmpty) {
                            snackBarMsg = "Phone number is required.";
                            showMySnackBar(snackBarMsg, _scaffoldKey);
                            return;
                          }

                          if ((_topUpType == "electricity") &
                              _meterNumberInputController.text.isEmpty) {
                            snackBarMsg = "Phone number is required.";
                            showMySnackBar(snackBarMsg, _scaffoldKey);
                            return;
                          }

                          if (_amountInputController.text.isEmpty) {
                            showMySnackBar("Amount is required.", _scaffoldKey);
                            return;
                          }

                          FocusScope.of(context).requestFocus(FocusNode());

                          authorizeTxnDialog(context, () {
                            _processTxn(
                              _topUpType,
                              pathName: "${_pageTitle.toLowerCase()}",
                            );
                          });
                        }),
          ],
        ),
      ),
    );
  }

  Future<void> _printData() async {
    try {
      var result = await platform.invokeMethod('printData', receiptData);
      // _clearInputFields();
      print(' result from native $result');
    } on PlatformException catch (e) {
      print('error occured $e');
    }
  }
}
