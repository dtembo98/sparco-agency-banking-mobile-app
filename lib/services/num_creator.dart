import 'dart:async';

class NumCreator {
  final StreamController _controller = StreamController<int>();
  int _count = 1;

  NumCreator() {
    Timer.periodic(Duration(seconds: 1), (t) {
      _controller.sink.add(_count);
      _count++;

      if (_count > 50) {
        t.cancel();
        _controller.sink.close();
      }
    });
  }

  Stream<int> get stream => _controller.stream;
}
