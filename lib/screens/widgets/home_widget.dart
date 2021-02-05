import 'package:shared_preferences/shared_preferences.dart';
import 'package:testingprintpos/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testingprintpos/screens/widgets/service_providers.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key key, @required this.optionStyle, this.iconSize = 30})
      : super(key: key);

  final TextStyle optionStyle;
  final double iconSize;

  Widget _buildExpandedBtn(BuildContext context, IconData iconData,
      String serviceName, String routeName,
      {String routeArgs, Color color}) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.all(5),
        child: InkWell(
          enableFeedback: true,
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: Icon(
                  iconData,
                  size: iconSize,
                  color: Colors.white,

                  // ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  serviceName,
                  style: ServiceBtnStyle.btnTxtStyle(context),
                ),
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

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Text(
                'Services',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
              Row(
                children: <Widget>[
                  _buildExpandedBtn(
                    context,
                    Icons.arrow_downward,
                    "Deposit",
                    "/deposit",
                  ),
                  _buildExpandedBtn(
                    context,
                    Icons.arrow_upward,
                    "Withdraw",
                    "/withdraw",
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            _buildExpandedBtn(
              context,
              Icons.phone_android,
              "Airtime",
              "/topup",
              routeArgs: "airtime",
            ),
            _buildExpandedBtn(
              context,
              Icons.lightbulb_outline,
              "Electricity",
              "/topup",
              routeArgs: "electricity",
            ),
          ],
        ),
        Row(
          children: <Widget>[
            _buildExpandedBtn(
              context,
              Icons.arrow_downward,
              " Cash In",
              "/cashin",
            ),
            _buildExpandedBtn(
              context,
              Icons.arrow_upward,
              "Cash Out",
              "/cashout",
            ),
          ],
        ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}

class ServiceBtnStyle {
  static TextStyle btnTxtStyle(BuildContext context) {
    return TextStyle(fontSize: 16, color: Colors.white);
  }
}
