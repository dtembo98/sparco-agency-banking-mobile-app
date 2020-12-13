import 'dart:collection';
import 'dart:io';

import 'package:o_popup/o_popup.dart';
import 'package:testingprintpos/models/settings.dart';
import 'package:testingprintpos/screens/widgets/home_widget.dart';
import 'package:testingprintpos/screens/widgets/profile_widget.dart';
import 'package:testingprintpos/screens/widgets/topbottomnav.dart';
import 'package:testingprintpos/screens/widgets/transactions_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stack/stack.dart' as customeStack;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  Settings settings;
  int popedIndex;
  String txnFilter = 'all';
  // customeStack.Stack<int> stack = customeStack.Stack<int>();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // List<Widget> _widgetList = [
  //   HomeWidget(optionStyle: optionStyle),
  //   TransactionsWidget(),
  //   ProfileWidget()
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // stack.push(index);
    // print(stack.top());
    // if (_selectedIndex == 1) {
    //   Navigator.pushNamed(context, '/transaction_details');
    // }
  }

  // Future<bool> _onBackButtonPress(index) {
  //   _onItemTapped(index);
  // }

  Future<Null> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<User>(context);
    // Stack<String> stack = Stack<String>();

    return Scaffold(
      appBar: _selectedIndex == 1
          ? AppBar(
              title: Text("Transactions"),
              actions: [
                new DropdownButton<String>(
                  value: txnFilter,
                  iconEnabledColor: Colors.white,
                  // style: TextStyle(color: Colors.white, fontSize: 18),
                  items: <String>[
                    'all',
                    'airtime',
                    'zesco',
                    'Withdraw',
                    'deposit',
                    'cashin',
                    'cashout',
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (String data) {
                    setState(() {
                      txnFilter = data;
                    });
                  },
                )
                // IconButton(icon: Icon(Icons.pin_drop), onPressed: null)
              ],
            )
          : AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
              leading: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  }),
              title: Text(
                "BroadPay Agent",
                // style: TextStyle(letterSpacing: 2),
              ),
              centerTitle: true,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      logOut();
                    }),
              ],
              bottom: (_selectedIndex == 0)
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(100.0),
                      child: TopBottomNav())
                  : null,
            ),
      // body: HomeWidget(optionStyle: optionStyle),

      body: WillPopScope(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomeWidget(optionStyle: optionStyle),
              TransactionsWidget(txnFilter.toLowerCase()),
              ProfileWidget(),
            ],
          ),
          onWillPop: () {
            if (_selectedIndex == 0) {
              setState(() {
                _selectedIndex = 2;
              });
            }
            if (_selectedIndex != 0) {
              setState(() {
                _selectedIndex = 0;
              });
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.deepPurple,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Transactions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
