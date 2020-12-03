import 'package:testingprintpos/services/num_creator.dart';
import 'package:flutter/material.dart';

class NumCreatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: NumCreator().stream.map((i) => 'Item  $i'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('No Data Yet');
        }
        if (snapshot.hasData) {
          return Text(snapshot.data);
        }
      },
    );
  }
}
