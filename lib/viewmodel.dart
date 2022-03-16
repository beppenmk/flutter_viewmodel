library viewmodel;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:viewmodel/base/usecase.dart';

import 'base/broadcast_stream_controller.dart';

class ViewModel {
  List<StreamController> controllers = [];

  void executeFuture<T>(Future<T> future,
      {BroadcastStream<T>? broadcastStreamController,
      StreamController<T>? controller}) {
    //CHECK INPUT (ONE SOURCE AND ONE DESTINATION)
    assert((broadcastStreamController == null && controller != null) ||
        (broadcastStreamController != null && controller == null));

    //ADD ONE OF THE TWO CONTROLLERS
    dynamic _controller;
    if (broadcastStreamController != null) {
      _controller = broadcastStreamController.controller;
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
      {BroadcastStream<O>? broadcastStreamController,
      StreamController<O>? controller}) {
    //CHECK INPUT (ONE SOURCE AND ONE DESTINATION)
    assert(params != null);
    assert((broadcastStreamController == null && controller != null) ||
        (broadcastStreamController != null && controller == null));

    //ADD ONE OF THE TWO CONTROLLERS
    dynamic _controller;
    if (broadcastStreamController != null) {
      _controller = broadcastStreamController.controller;
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
    controllers.forEach((controller) => controller.close());
    if (kDebugMode) {
      print("Disposed ${controllers.length} controllers");
    }
  }
}
