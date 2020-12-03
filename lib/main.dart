// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

// void main() async {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static const platform = const MethodChannel('samples.flutter.dev/battery');

//   var code;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   String _batteryLevel = 'Unknown battery level.';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("Bottom Nav Bar")),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _printData,
//         ),
//         body: Center(
//           child: Text("test printing hello $_batteryLevel"),
//         ));
//   }

//   // Get battery level.

//   Future<void> _printData() async {
//     DateTime now = DateTime.now();
//     String formatedDate = DateFormat('d/M/yy H:m').format(now);

//     Map<String, dynamic> receiptData = {
//       'agent': 'uncle vin',
//       'receipient': '0977322133',
//       'token': '4239 0934 7277 8436 7287',
//       'meter': '74000387261',
//       'amount': "k2",
//       'units': "Khw 2.0",
//       'txnDate': '${now.day}/${now.month}/${now.year}',
//       'txnTime': ' ${now.hour}:${now.minute} '
//     };

//     try {
//       var result = await platform.invokeMethod('printData', receiptData);
//       print(' receipt data $result');
//     } on PlatformException catch (e) {
//       print('error occured $e');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'models/settings.dart';
import 'models/txn_data.dart';
import 'route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TxnDataAdapter());
  await Hive.openBox('txnData');

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Settings())],
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Hive.openBox('txnData');
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    return MaterialApp(
      title: "BroadPay Agent",
      // theme: (settings.isDarkTheme) ? dark : light,
      theme: ThemeData(
          brightness:
              (settings.isDarkTheme) ? Brightness.dark : Brightness.light,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.primary,
          )),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

ThemeData light = ThemeData(
  brightness: Brightness.light,
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  // primarySwatch: Colors.indigo,
);
