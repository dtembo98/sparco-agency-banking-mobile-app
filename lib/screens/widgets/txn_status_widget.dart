import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/services/txn_status_service.dart';
import 'package:flutter/material.dart';

class TxnStatusWidget extends StatelessWidget {
  final int txnId;

  TxnStatusWidget({Key key, this.txnId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TxnData>(
      stream: TxnStatusService(txnId).stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('No Data Yet');
        }
        if (snapshot.hasData) {
          final TxnData txnData = snapshot.data;
          return Text(txnData.status);
        }
      },
    );
  }
}
