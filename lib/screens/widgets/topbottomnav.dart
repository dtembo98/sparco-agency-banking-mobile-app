import 'package:testingprintpos/services/user_service.dart';
import 'package:flutter/material.dart';

class TopBottomNav extends StatelessWidget {
  final UserService _userService = UserService();

  Widget _buildLedgerData(context, ledger) {
    // print('from widget ${ledger["ledgerBalance"]}');
    return Container(
      // color: Colors.transparent,
      height: 100.0,
      alignment: Alignment.center,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Float",
            style: TextStyle(fontSize: 35, color: Colors.white),
          ),
          Text(
            "ZMW ${ledger["ledgerBalance"]}",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userService.getLedger(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // TODO: Handle this case.
            // break;
            case ConnectionState.waiting:
            case ConnectionState.active:
              // TODO: Handle this case.
              return Padding(
                padding: EdgeInsets.all(25),
                child: SizedBox(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  height: 20.0,
                  width: 20.0,
                ),
              );
            case ConnectionState.done:
              print(snapshot.data);
              if (snapshot.hasError) {
                return Padding(
                    padding: EdgeInsets.all(25), child: Text(snapshot.error));
              }

              return _buildLedgerData(context, snapshot.data);
          }

          // _buildLedgerData(_userData)
        });
  }
}
