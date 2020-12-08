import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/services/txn_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  final int txnId;
  const TransactionPage({Key key, this.txnId}) : super(key: key);
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  TxnService _txnService = TxnService();

  String _parseDateTime(String dt) {
    DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy hh:mm:ss zzz");

    DateTime dateTime = dateFormat.parse(dt);

    return DateFormat("EEE, dd MMM yyyy hh:mm a")
        .format(dateTime.toLocal())
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction ID: ${widget.txnId}'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _txnService.getTxn(widget.txnId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TxnData _txnData = snapshot.data;
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("Transaction Type"),
                    subtitle: Text(_txnData.desc),
                  ),
                  (_txnData.token != null)
                      ? ListTile(
                          title: Text("Token"),
                          subtitle: Text(_txnData.token),
                        )
                      : SizedBox(),
                  ListTile(
                    title: Text("Amount"),
                    subtitle: Text("K ${_txnData.amount}"),
                  ),
                  ListTile(
                    title: Text("Commission"),
                    subtitle: Text("K ${_txnData.agentsCommission}"),
                  ),
                  ListTile(
                    title: Text("Status"),
                    subtitle: Text(
                      (_txnData.status == 'TXN_SUCCESSFUL')
                          ? "Processed"
                          : "Not Processed",
                      style: TextStyle(
                          color: (_txnData.status == 'TXN_SUCCESSFUL')
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                  ListTile(
                    title: Text("Sender"),
                    subtitle: Text(_txnData.sender),
                  ),
                  ListTile(
                    title: Text("Recipient"),
                    subtitle: Text(_txnData.recipient),
                  ),
                  ListTile(
                    title: Text("Date Time"),
                    subtitle: Text(_txnData.txnDateTime.toString()),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
