import 'package:testingprintpos/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // new line

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        SwitchListTile(
            secondary: Icon(Icons.palette),
            title: Text("Dark Mode"),
            value: settings.isDarkTheme,
            onChanged: (val) {
              settings.toggleTheme();
            }),
        ListTile(
          leading: Icon(Icons.security),
          title: Text('Require Authorization'),
          trailing: Checkbox(
            value: settings.reqAuth,
            onChanged: (val) {
              settings.toggleAuthReq();
            },
          ),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text("About"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.local_phone),
          title: Text("Contact Us"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.question_answer),
          title: Text("FAQ"),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
      ]),
    );
  }
}
