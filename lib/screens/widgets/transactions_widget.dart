import 'package:testingprintpos/models/txn_data.dart';
import 'package:testingprintpos/services/txns_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class TransactionsWidget extends StatefulWidget {
  @override
  _TransactionsWidgetState createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  // List<int> _items = [];
  bool _isLoadingData = false;
  int _curPage = 1;
  ScrollController _scrollController = ScrollController();
  List<TxnData> _txns = [];

  TxnsService _txnsService = TxnsService();
  bool _isError = false;
  String _errorMsg = '';

  // _loadData() async {
  //   try {
  //     if (!_isLoadingData) {
  //       setState(() => _isLoadingData = true);
  //       List<TxnData> loadedItems = await _txnsService.getTxns(page: _curPage);
  //       setState(() {
  //         _txns.addAll(loadedItems);
  //         _curPage += 1;
  //         _isLoadingData = false;
  //       });
  //     }
  //   } catch (e) {
  //     print("_txnsService error: $e ");
  //     if (!mounted) return;
  //     setState(() {
  //       _isError = true;
  //       _errorMsg = e.toString();
  //     });
  //   }
  // }

  Future<List<int>> fakeReq(int curPage, {int itemsPerPage: 10}) async {
    return Future.delayed(Duration(seconds: 5), () {
      int startAt = itemsPerPage * (curPage - 1);
      return List.generate(itemsPerPage, (i) => i + startAt);
    });
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: _isLoadingData ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  String _parseDateTime(String dt) {
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy hh:mm:ss zzz");
    // "EEE, dd MMM yyyy hh:mm a zzz"

    DateTime dateTime = dateFormat.parse(dt);

    // return dateTime.toLocal().toString();

    // return DateFormat("yyyy-MM-dd hh:mm a").format(dateTime.toLocal()).toString();
    return DateFormat("EEE, dd MMM yyyy hh:mm a")
        .format(dateTime.toLocal())
        .toString();
  }

  @override
  void initState() {
    super.initState();
    // _loadData();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _loadData();
    //   }
    // });
    // Hive.openBox('txnData');
    // print(Hive.box('txnData').values);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Hive.box('txnData').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hive.openBox('txnData');

    if ((_isError)) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _errorMsg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    } else {
      final txnBox = Hive.box('txnData');

      return ListView.builder(
        // scrollDirection: Axis.,
        // physics: ScrollPhysics(parent:),
        reverse: true,
        controller: _scrollController,
        itemCount: txnBox.length,
        itemBuilder: (context, index) {
          if (index == txnBox.length) {
            return _buildProgressIndicator();
          }

          final transactions = txnBox.get(index) as TxnData;
          // print('chai ${transactions.}');
          return Card(
            // decoration: BoxDecoration(border: Border(bottom: BorderSide())),
            child: ListTile(
              leading: Icon(
                // Icons.monetization_on,
                (transactions.status == 'TXN_SUCCESSFUL')
                    ? Icons.check_circle
                    : Icons.error,

                color: (transactions.status == 'TXN_SUCCESSFUL')
                    ? Colors.green
                    : Colors.yellow,
                size: 40,
              ),
              title: Text(transactions.desc),
              // subtitle: Text(_parseDateTime(transactions.txnDateTime)),
              subtitle: Text('${transactions.desc}'),
              trailing: Text(
                "K ${transactions.amount}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/transaction',
                    arguments: transactions.txnId);
              },
            ),
          );
        },
      );
    }
  }
}
