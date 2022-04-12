
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:viewmodel/base/broadcast_stream_controller.dart';
import 'package:viewmodel/vm.dart';

class BaseViewModel {

  List<StreamController> controllers = [];

  void executeFuture<T>(Future<T> future,
      {BroadcastStream<T>? broadcastStream,
        StreamController<T>? controller}) {
    //CHECK INPUT (ONE SOURCE AND ONE DESTINATION)
    assert((broadcastStream == null && controller != null) ||
        (broadcastStream != null && controller == null));

    //ADD ONE OF THE TWO CONTROLLERS
    dynamic _controller;
    if (broadcastStream != null) {
      _controller = broadcastStream.controller;
    } else if (controller != null) {
      _controller = controller;
    }

    controllers.add(_controller);

    //EXECUTE FUTURE
    future
        .then((result) => _controller.add(result))
        .catchError((error) => _controller.addError(error));
  }

  void executeUseCase<I, O>(UseCase<I, O> useCase, I params,
      {BroadcastStream<O>? broadcastStream,
        StreamController<O>? controller}) {
    //CHECK INPUT (ONE SOURCE AND ONE DESTINATION)
    assert(params != null);
    assert((broadcastStream == null && controller != null) ||
        (broadcastStream != null && controller == null));

    //ADD ONE OF THE TWO CONTROLLERS
    dynamic _controller;
    if (broadcastStream != null) {
      _controller = broadcastStream.controller;
    } else if (controller != null) {
      _controller = controller;
    }

    controllers.add(_controller);

    //EXECUTE USECASE
    useCase
        .execute(params)
        .then((result) => _controller.add(result))
        .catchError((error) => _controller.addError(error));
  }

  void dispose() {
    for (var controller in controllers) {
      controller.close();
    }
    if (kDebugMode) {
      print("Disposed ${controllers.length} controllers");
    }
    controllers.clear();
  }
}
