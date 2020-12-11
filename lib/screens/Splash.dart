import 'package:hive/hive.dart';
import 'package:testingprintpos/services/authentication.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String initUrl;
  AuthService _authService = AuthService();

  Future checkIsLogin() async {
    bool loginStatus = await _authService.checkLoginStatus();
    print(DateTime);
    Future.delayed(Duration(seconds: 5), () {
      print(loginStatus);
      // print(DateTime.now());
      // Navigator.of(context).pushReplacementNamed('/login');

      if (loginStatus) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Image.asset(
                'assets/icon/icon.png',
                fit: BoxFit.cover,
                width: 100,
              ),
              Text(
                "BroadPay",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
              Text(
                "Better Than Cash",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 4),
              )
            ])));
  }
}
