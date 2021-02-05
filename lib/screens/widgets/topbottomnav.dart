import 'package:testingprintpos/models/user_data.dart';
import 'package:testingprintpos/services/user_service.dart';
import 'package:flutter/material.dart';

class TopBottomNav extends StatelessWidget {
  final UserService _userService = UserService();

  Widget _buildLedgerData(context, UserData user) {
    print('from widget ${user.float}');

    return Container(
      // color: Colors.transparent,
      height: 100.0,
      alignment: Alignment.center,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Ledger",
            style: TextStyle(fontSize: 35, color: Colors.white),
          ),
          Text(
            "ZMW ${user.ledgerBalance}",
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userService.getUser(),
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
              if (snapshot.hasError) {
                return Padding(
                    padding: EdgeInsets.all(25), child: Text('user not found'));
              }

              return _buildLedgerData(context, snapshot.data);
          }

          // _buildLedgerData(_userData)
        });
  }
}
