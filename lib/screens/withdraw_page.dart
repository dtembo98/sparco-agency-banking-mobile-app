import 'dart:async';
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/screens/widgets/authorize_txn_widget.dart';
import 'package:testingprintpos/services/txn_service.dart';
import 'package:testingprintpos/services/txn_status_service.dart';
import 'package:testingprintpos/utils/app_snackbar.dart';
import 'package:flutter/material.dart';

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _msisdnInputController = TextEditingController();
  TextEditingController _amountInputController = TextEditingController();
  TextEditingController _refInputController = TextEditingController();
  bool _isLoading = false;
  bool _txnSucceeded = false;
  int _txnId;
  String _statusMsg = "";
  TxnService _txnService = TxnService();
  StreamSubscription txnStatusSub;

  String _msisdnInputVal;
  String _amountInputVal;

  void _processTxn(String txnType) async {
    String msisdn = _msisdnInputController.text;
    double amount = double.parse(_amountInputController.text);
    String ref = _refInputController.text;

    setState(() {
      _isLoading = true;
      _statusMsg = "";
    });

    TxnData _txnData =
        await _txnService.processTxn(txnType, msisdn, amount, ref: ref);

    print(_txnData.isError);
    print(_txnData.status);
    print(_txnData.txnId);

    if (_txnData.isError) {
      setState(() {
        _statusMsg =
            _txnData.msg ?? "Error Occured, Couldn't process transaction";
        _isLoading = false;
        _txnSucceeded = false;
        _txnId = _txnData.txnId;
      });

      return;
    }

    Stream<TxnData> txnStatusStream = TxnStatusService(_txnData.txnId).stream;

    txnStatusSub = txnStatusStream.listen((txnData) {
      String txnStatus = txnData.status;
      _txnId = txnData.txnId;

      String txnStatusMsg = "";

      if (txnStatus == 'TXN_AUTH_PENDING') {
        txnStatusMsg = 'Waiting For Authorization. TxnID: $_txnId';
      } else if (txnStatus == 'TXN_AUTH_UNSUCCESSFUL') {
        txnStatusMsg = 'Transaction Authorization Failed';
        setState(() {
          _txnSucceeded = false;
        });
      } else if (txnStatus == 'TXN_SUCCESSFUL') {
        txnStatusMsg = 'Transaction was successful';
        setState(() {
          _txnSucceeded = true;
        });
      } else {
        txnStatusMsg = '';
      }
      setState(() {
        _statusMsg = txnStatusMsg;
      });

      if ((txnStatus == 'TXN_AUTH_UNSUCCESSFUL') |
          (txnStatus == 'TXN_SUCCESSFUL')) {
        setState(() {
          _isLoading = false;
        });
        txnStatusSub.cancel();
      }
    }, onError: (err) {
      print('Err: $err');
    }, onDone: () {
      setState(() {
        _isLoading = false;
      });
    }, cancelOnError: true);
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
        title: Text("Withdraw"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(children: <Widget>[
          TextField(
            controller: _msisdnInputController..text = _msisdnInputVal,
            decoration: InputDecoration(
                labelText: "Withdrawer's Number",
                hintText: "Enter Withdrawer's Number",
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
                            child: Text("Perform Another Withdraw"),
                            // icon: Icon(Icons.refresh),
                            onPressed: () {
                              _clearInputFields();
                              //  _processTxn('withdraw');
                            }),
                        Container(
                          // opacity: (_txnSucceeded) ? 0 : 1,
                          child: _txnSucceeded
                              ? null
                              : RaisedButton(
                                  child: Text("Try Again"),
                                  onPressed: () {
                                    //  _clearInputFields();
                                    _processTxn('withdraw');
                                  }),
                        )
                      ],
                    )
                  : RaisedButton(
                      child: Text("Withdraw"),
                      onPressed: () {
                        if (_msisdnInputController.text.isEmpty) {
                          showMySnackBar(
                              "Withdrawer's number is required.", _scaffoldKey);
                          return;
                        }

                        if (_amountInputController.text.isEmpty) {
                          showMySnackBar("Amount is required.", _scaffoldKey);
                          return;
                        }

                        FocusScope.of(context).requestFocus(FocusNode());
                        authorizeTxnDialog(context, () {
                          _processTxn('withdraw');
                        });
                      }),
          SizedBox(height: 10),
          Center(child: Text(_statusMsg))
        ]),
      ),
    );
  }
}
