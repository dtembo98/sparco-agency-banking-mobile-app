import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Error Page'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                }),
          ],
        ),
        body: Center(
          child: Text('Error'),
        ));
  }
}
