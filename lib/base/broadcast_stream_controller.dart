



import 'dart:async';

class BroadcastStream<T> {
  StreamController<T>? controller;
  Stream<T>? stream;

  BroadcastStream() {
    controller = StreamController<T>.broadcast();
    stream = controller!.stream;
  }

  void dispose(){
    controller?.close();
  }
}