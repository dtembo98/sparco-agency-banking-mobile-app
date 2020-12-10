import 'dart:async';
import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/screens/widgets/authorize_txn_widget.dart';
import 'package:testingprintpos/services/txn_service.dart';
import 'package:testingprintpos/services/txn_status_service.dart';
import 'package:testingprintpos/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:testingprintpos/utils/constants.dart';

class CashInPage extends StatefulWidget {
  @override
  _CashInPageState createState() => _CashInPageState();
}

class _CashInPageState extends State<CashInPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _msisdnInputController =
      TextEditingController(text: WalletNumber);
  TextEditingController _amountInputController =
      TextEditingController(text: "0.3");
  TextEditingController _refInputController = TextEditingController();
  bool _isLoading = false;
  bool _txnSucceeded = false;
  int _txnId;
  String _statusMsg = "";
  TxnService _txnService = TxnService();

  StreamSubscription txnStatusSub;

  String _msisdnInputVal;
  String _amountInputVal;

  void _processTxn(
      {@required String txnType, @required String pathName}) async {
    String msisdn = _msisdnInputController.text;
    double amount = double.parse(_amountInputController.text);
    String ref = _refInputController.text;

    setState(() {
      _isLoading = true;
      _statusMsg = "";
    });

    TxnData _txnData = await _txnService.processTxn(txnType, msisdn, amount,
        pathName: pathName);
    print(" geting id hhere ${_txnData.txnId}");
    Stream<TxnData> txnStatusStream = TxnStatusService(_txnData.txnId).stream;

    txnStatusSub = txnStatusStream.listen((txnData) {
      String txnStatus = txnData.status;
      _txnId = txnData.txnId;

      String txnStatusMsg = "";
      print(' data bo be proceesed ${txnStatus}');
      // print('kllkjdslkfjsldf kljdkfjsd kjslajdakl $txnStatus');
      if (txnStatus == 'TXN_AUTH_PENDING') {
        txnStatusMsg = 'Waiting For Authorization. TxnID: ${_txnData.txnId}';
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
        title: Text("Cash In"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ListView(children: <Widget>[
          TextField(
            controller: _msisdnInputController..text = _msisdnInputVal,
            decoration: InputDecoration(
                labelText: "Mobile Wallet Number",
                hintText: "Enter Your Mobile Waller Number",
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
                            child: Text("Cash In Again"),
                            // icon: Icon(Icons.refresh),
                            onPressed: () {
                              _clearInputFields();
                            }),
                        Container(
                          // opacity: (_txnSucceeded) ? 0 : 1,
                          child: _txnSucceeded
                              ? null
                              : RaisedButton(
                                  child: Text("Try Again"),
                                  onPressed: () {
                                    //  _clearInputFields();
                                    _processTxn(
                                        txnType: 'cashin', pathName: 'cashin');
                                  }),
                        )
                      ],
                    )
                  : RaisedButton(
                      child: Text("Cash In"),
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
                        // focusNode.unfocus();
                        FocusScope.of(context).requestFocus(FocusNode());
                        // _processTxn('cashin');

                        authorizeTxnDialog(context, () {
                          // print("Callback Called When Transaction Authorized");
                          _processTxn(txnType: 'cashin', pathName: 'cashin');
                        });
                      }),
          SizedBox(height: 10),
          Center(child: Text(_statusMsg))
        ]),
      ),
    );
  }
}
