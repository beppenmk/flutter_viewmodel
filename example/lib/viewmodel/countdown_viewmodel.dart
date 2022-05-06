import 'dart:async';

import 'package:flutter_vm/vm.dart';

class TimerViewModel extends BaseViewModel {
  int number = 0;
  int _number = 0;
  Timer? _timer;

  final numberStream = BroadcastStream<int>();

  TimerViewModel(this.number) {
    _number = number;
  }

  Future<int> _decrement() async => Future.value(--number);

  void play() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      executeFuture(_decrement(), broadcastStream: numberStream);
    });
  }

  void pause() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void stop() {
    number = _number;
    numberStream.controller?.add(_number);
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    numberStream.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
