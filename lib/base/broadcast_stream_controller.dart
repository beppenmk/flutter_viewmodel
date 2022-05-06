import 'dart:async';

///this is a wrapper for sugar code
class BroadcastStream<T> {
  StreamController<T>? controller;
  Stream<T>? stream;

  BroadcastStream() {
    controller = StreamController<T>.broadcast();
    stream = controller!.stream;
  }

  void dispose() {
    controller?.close();
  }
}
