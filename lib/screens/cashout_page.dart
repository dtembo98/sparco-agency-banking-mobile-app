import 'dart:async';
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/screens/widgets/authorize_txn_widget.dart';
import 'package:testingprintpos/services/txn_service.dart';
import 'package:testingprintpos/utils/app_snackbar.dart';
import 'package:flutter/material.dart';

class CashOutPage extends StatefulWidget {
  @override
  _CashOutPageState createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _msisdnInputController = TextEditingController();
  TextEditingController _amountInputController = TextEditingController();
  TextEditingController _refInputController = TextEditingController();
  bool _isLoading = false;
  bool _txnSucceeded = true;
  String statusMsg = "";
  TxnService _txnService = TxnService();
  int _txnId;
  StreamSubscription txnStatusSub;
  String _statusMsg = "";

  String _amountInputVal;

  void _processTxn(String txnType, {@required String pathName}) async {
    String msisdn = _msisdnInputController.text;
    double amount = double.parse(_amountInputController.text);
    String ref = _refInputController.text;

    setState(() {
      _isLoading = true;
      _statusMsg = "";
    });

    TxnData _txnData = await _txnService.processTxn(txnType, msisdn, amount,
        ref: ref, pathName: pathName);

    String txnStatus = _txnData.status;

    print('txnStatus');
    print(txnStatus);

    if (_txnData.status == 'TXN_UNSUCCESSFUL') {
      _statusMsg = _txnData.msg ?? 'Cash out failed';
      _txnSucceeded = false;
    }

    if (_txnData.status == 'TXN_SUCCESSFUL') {
      _statusMsg = 'Cash out was successful';
      _txnSucceeded = true;
    }

    setState(() {
      _isLoading = false;
      _statusMsg = _statusMsg;
      _txnId = _txnData.txnId;
      _txnSucceeded = _txnSucceeded;
    });
  }

  void _clearInputFields() {
    _msisdnInputController.clear();
    _amountInputController.clear();
    setState(() {
      _statusMsg = "";
      _txnId = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (txnStatusSub != null) {
      txnStatusSub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cash Out"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(children: <Widget>[
          TextField(
            // controller: _msisdnInputController..text = _msisdnInputVal,
            controller: _msisdnInputController,
            decoration: InputDecoration(
                labelText: "Mobile Wallet Number",
                hintText: "Enter Your Mobile Wallet Number",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              print(val);
            },
          ),
          SizedBox(height: 10),
          TextField(
            controller: _amountInputController..text = _amountInputVal,
            decoration: InputDecoration(
                labelText: "Amount",
                hintText: "Enter Amount",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              print(val);
            },
          ),
          SizedBox(height: 10),
          (_isLoading)
              ? Center(child: CircularProgressIndicator())
              : (_txnId != null)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        RaisedButton(
                            child: Text("Perform Another Cash Out"),
                            // icon: Icon(Icons.refresh),
                            onPressed: () {
                              _clearInputFields();
                              //  _processTxn('withdraw');
                            }),
                        Container(
                          // opacity: _txnSucceeded ? 0 : 1,
                          child: _txnSucceeded
                              ? null
                              : RaisedButton(
                                  child: Text("Try Again"),
                                  onPressed: () {
                                    //  _clearInputFields();
                                    _processTxn('cashout', pathName: 'cashout');
                                  }),
                        )
                      ],
                    )
                  : RaisedButton(
                      child: Text("Cash Out"),
                      onPressed: () {
                        if (_msisdnInputController.text.isEmpty) {
                          showMySnackBar("Mobile wallet number is required.",
                              _scaffoldKey);
                          return;
                        }

                        if (_amountInputController.text.isEmpty) {
                          showMySnackBar("Amount is required.", _scaffoldKey);
                          return;
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                        authorizeTxnDialog(context, () {
                          _processTxn('cashout', pathName: 'cashout');
                        });
                      }),
          SizedBox(height: 10),
          Center(child: Text(_statusMsg))
        ]),
      ),
    );
  }
}
