import 'package:testingprintpos/models/user_data.dart';
import 'package:testingprintpos/screens/widgets/change_password_widget.dart';
import 'package:testingprintpos/services/user_service.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final UserService _userService = UserService();

  Widget _buildProfileData(UserData _userData) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            "PERSONAL INFO",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          title: Text("Name"),
          subtitle: Text("${_userData.fname} ${_userData.lname}"),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Phone"),
          subtitle: Text("${_userData.phone}"),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Email"),
          subtitle: Text(_userData.email ?? ""),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Change password"),
          subtitle: Text("*****"),
          trailing: Icon(Icons.edit),
          onTap: () {
            // _showDialog(context);
            changePasswordDialog(context);
          },
        ),
        Divider(
          height: 5,
          thickness: 5,
          color: Colors.black26,
        ),
        ListTile(
          title: Text(
            "KYC",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          title: Text("Identification(NRC)"),
          subtitle: Text(_userData.nrc ?? ""),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Identification(Passport)"),
          // subtitle: Text(_userData.passport ?? ""),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Address"),
          subtitle: Text(_userData.address ?? ""),
          // trailing: Icon(Icons.edit),
        ),
        Divider(
          height: 5,
          thickness: 5,
          color: Colors.black26,
        ),
        ListTile(
          title: Text(
            "ACCOUNT INFO",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ListTile(
          title: Text("Account Type"),
          subtitle: Text("Admin | Agent"),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Ledger Balance"),
          subtitle: Text('K ${_userData.ledgerBalance}' ?? ""),
          // trailing: Icon(Icons.edit),
        ),
        ListTile(
          title: Text("Float"),
          subtitle: Text('K ${_userData.float}' ?? ""),
          // trailing: Icon(Icons.edit),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userService.getUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:

            ///when data is being fetched
            case ConnectionState.waiting:
              return Center(
                // child: CircularProgressIndicator(
                //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
              );

            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              print(snapshot.data);
              return _buildProfileData(snapshot.data);

            case ConnectionState.none:
          }
        });
  }
}
