import 'package:flutter/material.dart';

class ServiceProviders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8, right: 2),
              color: Colors.green, // Yellow
              height: 130.0,
              width: 130.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 2),
              color: Colors.pink,
              height: 130.0,
              width: 130.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 2),
              color: Colors.redAccent,
              height: 130.0,
              width: 130.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 8, right: 2),
              color: Colors.redAccent,
              height: 130.0,
              width: 130.0,
            ),
          ],
        ),
      ),
    );
  }
}
