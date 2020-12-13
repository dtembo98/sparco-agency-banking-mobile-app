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
        // color: color,

        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(100.0))),
        margin: EdgeInsets.all(5),
        child: InkWell(
          enableFeedback: true,
          child: Column(
            children: <Widget>[
              // Material(
              // elevation: 4.0,
              // shape: CircleBorder(),
              // color: Colors.amberAccent,
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

  // void initState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   print(prefs);
  // }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return ListView(
      children: <Widget>[
        // Card(
        //   margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: <Widget>[
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text("SERVICES"),
        //       ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              // Text(
              //   'Service Providers',
              //   textAlign: TextAlign.left,
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // ServiceProviders(),
              // SizedBox(
              //   height: 20,
              // ),
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
