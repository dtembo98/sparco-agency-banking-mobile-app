import 'package:testingprintpos/services/authentication.dart';
import 'package:flutter/material.dart';

class PasscodeResetPage extends StatefulWidget {
  @override
  _PasscodeResetPageState createState() => _PasscodeResetPageState();
}

class _PasscodeResetPageState extends State<PasscodeResetPage> {
  bool _isLoading = false;
  String _phone;
  AuthService _authService = AuthService();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _agentIdController = TextEditingController();

  TextEditingController _resetCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _msg;
  String agentId;
  Future<void> _confirmPasscodeReset() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reset Passcode?',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Confirm passcode reset for $_phone.',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Proceed'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                  // _phone = _phoneController.text;
                });
                _authService.resetPasscode(_phone).then((isReset) {
                  print(' resetting password $isReset');

                  if (isReset) {
                    _finalReset();
                  } else {
                    _msg = "Passcode reset failed";
                  }
                }).whenComplete(() {
                  setState(() {
                    _isLoading = false;
                    _msg = _msg;
                  });
                });
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
      },
    );
  }

  Future<void> _finalReset() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Agent ID',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  // readOnly: true,
                  controller: _resetCodeController,
                  decoration: InputDecoration(
                      labelText: "Agent ID",
                      hintText: "Enter Your Agent ID ",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Proceed'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                  // _phone = _phoneController.text;
                });
                _authService
                    .finalresetPasscode(_resetCodeController.text)
                    .then((isFinalReset) {
                  print(' resetting password $isFinalReset');

                  // if (isFinalReset) {
                  //   _msg = "Passcode successfully reset";
                  //   // Navigator.pushNamed(context, '/login');
                  // } else {
                  //   _msg = "Passcode reset failed";
                  // }
                }).whenComplete(() {
                  setState(() {
                    _isLoading = false;
                    // _msg = _msg;
                  });
                });
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Passcode"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              // readOnly: true,
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: "Phone Number",
                  hintText: "Enter Your Phone Number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(
              height: 20,
            ),
            (_isLoading)
                ? Center(child: CircularProgressIndicator())
                : RaisedButton(
                    child: Text('Proceed'),
                    onPressed: () {
                      setState(() {
                        // _isLoading = true;
                        _phone = _phoneController.text;
                      });
                      if (_phone.isNotEmpty) {
                        _confirmPasscodeReset();
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Phone field can't be empty.",
                              style: TextStyle(color: Colors.red),
                            ),
                            duration: Duration(seconds: 10),
                          ),
                        );
                      }
                    },
                  ),
            Text(
              _msg ?? '',
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
