import 'package:flutter_vm/vm.dart';

class CounterViewModel extends BaseViewModel {
  CounterViewModel();

  final number = BroadcastStream<int>();

  Future<int> _increment(int value) async {
    await Future.delayed(const Duration(seconds: 1));

    return Future.value(value + 1);
  }

  increment(int value) {
    executeFuture(_increment(value), broadcastStream: number);
  }
}
