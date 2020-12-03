import 'package:flutter/material.dart';

void showMySnackBar(String msg, GlobalKey<ScaffoldState> scaffoldKey) {
  final snackBar = SnackBar(
    content: Text(msg),
    // backgroundColor: Colors.red,
  );
  scaffoldKey.currentState.showSnackBar(snackBar);
}
