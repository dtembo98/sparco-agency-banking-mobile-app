import 'package:testingprintpos/services/authentication.dart';
import 'package:flutter/material.dart';

class ChangePasswordWidgetContent extends StatefulWidget {
  final Function onProcessCallBack;

  ChangePasswordWidgetContent({Key key, this.onProcessCallBack})
      : super(key: key);

  @override
  _ChangePasswordWidgetContentState createState() =>
      _ChangePasswordWidgetContentState();
}

class _ChangePasswordWidgetContentState
    extends State<ChangePasswordWidgetContent> {
  bool _isLoading = false;
  TextEditingController _curPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _newPassword2Controller = TextEditingController();
  AuthService _authService = AuthService();
  String _msg = "";
  List<String> _errorMessages = [];

  void _changePassword() {
    setState(() {
      _isLoading = true;
    });

    String _curPassword = _curPasswordController.text;
    String _newPassword = _newPasswordController.text;
    String _newPassword2 = _newPassword2Controller.text;

    List<String> _errs = [];

    if (_curPassword.isEmpty) {
      _errs.add("Current password can't be empty.");
    }
    if (_newPassword.isEmpty) {
      _errs.add("New password can't be empty.");
    }
    if (_newPassword != _newPassword2) {
      _errs.add("New passwords must match.");
    }
    print(_errs);
    if (_errs.isNotEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessages = _errs;
      });
    }

    _authService
        .changePassword(_curPassword, _newPassword, _newPassword2)
        .then((passwordChanged) {
      print('passwordChanged');
      print(passwordChanged);
      if (passwordChanged) {
        print("Process Txn");
        _msg = "Password successfully changed";
      } else {
        _msg = "Error change password";
      }
    }).catchError((err) {
      print("Password Change Error $err");
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _curPasswordController,
              decoration: InputDecoration(
                  labelText: "Current Password",
                  hintText: "Enter your current password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (val) {
                print(val);
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                  labelText: "New Password",
                  hintText: "Enter new password password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (val) {
                print(val);
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPassword2Controller,
              decoration: InputDecoration(
                  labelText: "Repeat New Password",
                  hintText: "Repeat new password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (val) {
                print(val);
              },
            ),
            Text(
              _msg,
              textAlign: TextAlign.center,
              // style: TextStyle(color: Colors.red),
            ),
            Column(
              children: _errorMessages.map((errMsg) => Text(errMsg)).toList(),
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
                  _changePassword();
                },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            // _isLoading = false;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    ;
  }
}

Future<void> changePasswordDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ChangePasswordWidgetContent(onProcessCallBack: () {});
    },
  );
}
