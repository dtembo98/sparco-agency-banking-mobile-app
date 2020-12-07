import 'package:testingprintpos/screens/Splash.dart';
import 'package:testingprintpos/screens/cashin_page.dart';
import 'package:testingprintpos/screens/cashout_page.dart';
import 'package:testingprintpos/screens/deposit_page.dart';
import 'package:testingprintpos/screens/error_page.dart';
import 'package:testingprintpos/screens/login_page.dart';
import 'package:testingprintpos/screens/main_page.dart';
import 'package:testingprintpos/screens/passcode_reset_page.dart';
import 'package:testingprintpos/screens/service_page.dart';
import 'package:testingprintpos/screens/settings_page.dart';
import 'package:testingprintpos/screens/topup_page.dart';
import 'package:testingprintpos/screens/transaction_page.dart';
import 'package:testingprintpos/screens/withdraw_page.dart';
import 'package:flutter/material.dart';

import 'screens/widgets/transactions_widget.dart';
// import 'package:provider/provider.dart';

// import 'models/user.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // if (args is String) {
      //   return MaterialPageRoute(
      //       builder: (_) => MainPage(
      //           // uid: args,
      //           ));
      // }
      // return MaterialPageRoute(
      //   builder: (_) => ErrorPage(),
      // );
      case '/':
        return MaterialPageRoute(
            builder: (_) => Splash(
                // uid: args,
                ));
      case '/home':
        return MaterialPageRoute(
            builder: (_) => MainPage(
                // uid: args,
                ));
      case '/login':
        return MaterialPageRoute(builder: (_) {
          // User user = Provider.of<User>(context);
          return LoginPage();
        });

      case '/settings':
        return MaterialPageRoute(builder: (_) {
          return SettingsPage();
        });

      case '/service':
        return MaterialPageRoute(builder: (_) {
          return ServicePage();
        });

      case '/withdraw':
        return MaterialPageRoute(builder: (_) {
          return WithdrawPage();
        });

      case '/deposit':
        return MaterialPageRoute(builder: (_) {
          return DepositPage();
        });

      case '/transaction':
        return MaterialPageRoute(builder: (_) {
          return TransactionPage(
            txnId: args,
          );
        });
      case '/transaction_details':
        return MaterialPageRoute(builder: (_) {
          // return TransactionsWidget();
        });
      case '/topup':
        return MaterialPageRoute(builder: (_) {
          return TopUpPage(
            topUpType: args,
          );
        });
      case '/cashin':
        return MaterialPageRoute(builder: (_) {
          return CashInPage();
        });

      case '/cashout':
        return MaterialPageRoute(builder: (_) {
          return CashOutPage();
        });
      case '/passcodereset':
        return MaterialPageRoute(builder: (_) {
          return PasscodeResetPage();
        });
      default:
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
    }
  }
}
