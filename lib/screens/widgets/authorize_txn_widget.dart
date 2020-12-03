import 'package:testingprintpos/services/authentication.dart';
import 'package:flutter/material.dart';

class AuthTxnWidgetContent extends StatefulWidget {
  final Function onProcessCallBack;

  AuthTxnWidgetContent({Key key, this.onProcessCallBack}) : super(key: key);

  @override
  _AuthTxnWidgetContentState createState() => _AuthTxnWidgetContentState();
}

class _AuthTxnWidgetContentState extends State<AuthTxnWidgetContent> {
  bool _isLoading = false;
  TextEditingController _passCodeController = TextEditingController();
  AuthService _authService = AuthService();
  String _msg;

  void _authorizeTxn(String password) {
    setState(() {
      _isLoading = true;
      _msg = "Authorizing Transaction";
    });

    _authService.authTxn(password).then((txnAuthStatus) {
      print('txnAuthStatus');
      print(txnAuthStatus);
      if (txnAuthStatus) {
        print("Process Txn");
        _msg = "Transaction Authorized";
        widget.onProcessCallBack();

        Navigator.of(context).pop();
      } else {
        _msg = "Error authorizing transaction";
      }
    }).catchError((err) {
      print("Txn Auth $err");
      _msg = err.toString();
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
        _msg = _msg;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter passcode to proceed.',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            (_isLoading)
                ? Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TextField(
                    controller: _passCodeController,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: "Enter Passcode",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                    keyboardType: TextInputType.number,
                  ),
            Text(
              _msg ?? "",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Proceed'),
          onPressed: _isLoading
              ? null
              : () {
                  String _passCode = _passCodeController.text;

                  _authorizeTxn(_passCode);
                },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    ;
  }
}

Future<void> authorizeTxnDialog(
    BuildContext context, Function processTxnCallBack) async {
  // bool _isLoading = true;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AuthTxnWidgetContent(onProcessCallBack: () {
        processTxnCallBack();
      });
    },
  );
}
