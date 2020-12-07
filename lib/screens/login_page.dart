import 'package:testingprintpos/models/settings.dart';
import 'package:testingprintpos/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testingprintpos/utils/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthService _authService = AuthService();
  String _phone;
  String _password;
  bool _loggingIn = false;

  // Future checkIsLogin() async {
  //   bool loginStatus = await _authService.checkLoginStatus();

  //   if (loginStatus) {
  //     Navigator.pushReplacementNamed(context, '/', arguments: "Mundia");
  //   }
  // }

  Future _login() async {
    setState(() {
      _loggingIn = true;
    });

    try {
      bool _isLoggedin = await _authService.login(_phone, _password);
      if (_isLoggedin) {
        Navigator.pushReplacementNamed(context, '/home', arguments: "");
      } else {
        _showSnackBar("Invalid Phone or Passcode.");
      }
    } catch (e) {
      _showSnackBar(e.toString());
    }

    setState(() {
      _loggingIn = false;
    });
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      // backgroundColor: Colors.red,
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _neverSatisfied() async {
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
                (_phone != null)
                    ? Text(
                        'Confirm passcode reset for 0961453688.',
                        textAlign: TextAlign.center,
                      )
                    : TextField(),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Proceed'),
              onPressed: () {
                // Navigator.of(context).pop();
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
  void initState() {
    super.initState();
    // checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            // Icon(
            //   Icons.account_balance_wallet,
            //   size: 100,
            // ),
            Image.asset(
              'assets/icon/icon.png',
              fit: BoxFit.cover,
              width: 100,
            ),
            Text(
              "BroadPay Agent",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: AgentNumber,
                        decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "Enter Your Phone Number",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => _phone = val,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter phone';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //
                      TextFormField(
                        initialValue: AgentPassword,
                        decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter Your Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        obscureText: false,
                        onSaved: (val) => _password = val,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      (_loggingIn)
                          ? SizedBox(
                              child: CircularProgressIndicator(),
                              height: 20.0,
                              width: 20.0,
                            )
                          : RaisedButton(
                              // color: Colors.deepPurple,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.arrow_forward),
                                  Text('Login')
                                ],
                              ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                final form = _formKey.currentState;
                                if (form.validate()) {
                                  form.save();
                                  _login();
                                }
                              }),
                      MaterialButton(
                          child: Text("Reset Password"),
                          onPressed: () {
                            // _neverSatisfied();
                            Navigator.pushNamed(context, '/passcodereset');
                          })
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
