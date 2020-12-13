import 'dart:async';
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/screens/widgets/authorize_txn_widget.dart';
import 'package:testingprintpos/services/txn_service.dart';
import 'package:testingprintpos/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositPage extends StatefulWidget {
  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
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

  String _msisdnInputVal;
  String _amountInputVal;

  List<Widget> _availableServices() {
    List<String> serviceNames = [
      'MTN Money',
      'Airtel Money',
      'Zampay',
    ];
    List<Widget> services = [];

    services.addAll(serviceNames.map((serviceName) {
      return _buildServiceBtn(serviceName);
    }));

    return services;
  }

  Widget _buildServiceBtn(String serviceName) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 20,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green)),
          onPressed: () {},
          color: Colors.green,
          textColor: Colors.white,
          child: Text(serviceName.toUpperCase(), style: TextStyle(fontSize: 8)),
        ),
      ),
    );
  }

  void _processTxn(String txnType, {@required String pathName}) async {
    String msisdn = _msisdnInputController.text;
    double amount = double.parse(_amountInputController.text);
    String ref = _refInputController.text;

    // msisdn.isEmpty

    setState(() {
      _isLoading = true;
      _statusMsg = "";
    });

    TxnData _txnData = await _txnService.processTxn(txnType, msisdn, amount,
        ref: ref, pathName: pathName);

    String txnStatus = _txnData.status;

    print('_txnData');
    print(_txnData.toString());
    print('txnStatus');
    print(txnStatus);

    if ((_txnData.status == 'TXN_UNSUCCESFULL') |
        (_txnData.status == 'AMOUNT_BELOW_MIN') |
        (_txnData.status == 'AMOUNT_ABOVE_MAX') |
        (_txnData.status == 'UNSUPPORTED_PROVIDER')) {
      _statusMsg = _txnData.msg ?? 'Transaction Failed';
      _txnSucceeded = false;
    }

    if (_txnData.status == 'TXN_SUCCESSFUL') {
      _statusMsg = 'Transaction was successful';
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
        title: Text("Deposit"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(children: <Widget>[
          TextField(
            controller: _msisdnInputController..text = _msisdnInputVal,
            decoration: InputDecoration(
                labelText: "Depositor's Number",
                hintText: "Enter Depositor's Number",
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
          TextField(
            controller: _refInputController,
            decoration: InputDecoration(
                labelText: "Reference(Optional)",
                hintText: "Enter Reference",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            keyboardType: TextInputType.text,
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
                            child: Text("Perform Another Deposit"),
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
                                    _processTxn('deposit', pathName: 'deposit');
                                  }),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                      _statusMsg,
                      style: TextStyle(color: Colors.redAccent),
                    )),
          SizedBox(height: 10),
          RaisedButton(
              child: Text("Deposit"),
              onPressed: () {
                // _submitService();

                // _processTxn('deposit');
                if (_msisdnInputController.text.isEmpty) {
                  showMySnackBar(
                      "Depositor's number is required.", _scaffoldKey);
                  return;
                }

                if (_amountInputController.text.isEmpty) {
                  showMySnackBar("Amount is required.", _scaffoldKey);
                  return;
                }
                FocusScope.of(context).requestFocus(FocusNode());

                authorizeTxnDialog(context, () {
                  // print("Callback Called When Transaction Authorized");
                  _processTxn('deposit', pathName: 'deposit');
                });
              }),
        ]),
      ),
    );
  }
}
