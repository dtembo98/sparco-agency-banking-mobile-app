import 'package:shared_preferences/shared_preferences.dart';
import 'package:testingprintpos/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key key, @required this.optionStyle, this.iconSize = 30})
      : super(key: key);

  final TextStyle optionStyle;
  final double iconSize;

  Widget _buildExpandedBtn(BuildContext context, IconData iconData,
      String serviceName, String routeName,
      {String routeArgs}) {
    return Expanded(
      child: Container(
        height: 100,
        margin: EdgeInsets.all(10),
        child: InkWell(
          child: Column(
            children: <Widget>[
              Material(
                elevation: 4.0,
                shape: CircleBorder(),
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    iconData,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                serviceName,
                style: ServiceBtnStyle.btnTxtStyle(context),
              )
            ],
          ),
          onTap: () {
            // Navigator.pushNamed(context, '/deposit');
            Navigator.pushNamed(context, routeName, arguments: routeArgs);
          },
        ),
      ),
    );
  }

  // void initState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   print(prefs);
  // }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return ListView(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("SERVICES"),
              ),
              Row(
                children: <Widget>[
                  _buildExpandedBtn(
                      context, Icons.arrow_downward, "Deposit", "/deposit"),
                  _buildExpandedBtn(
                      context, Icons.arrow_upward, "Withdraw", "/withdraw"),
                  _buildExpandedBtn(
                      context, Icons.phone_android, "Airtime", "/topup",
                      routeArgs: "airtime"),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildExpandedBtn(
                      context, Icons.lightbulb_outline, "Zesco", "/topup",
                      routeArgs: "electricity"),
                  _buildExpandedBtn(
                      context, Icons.arrow_downward, " Cash In", "/cashin"),
                  _buildExpandedBtn(
                      context, Icons.arrow_upward, "Cash Out", "/cashout"),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ServiceBtnStyle {
  static TextStyle btnTxtStyle(BuildContext context) {
    return TextStyle(fontSize: 15);
  }
}
