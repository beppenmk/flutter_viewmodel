import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_vm/vm.dart';

/// this is the base viewmodel
class BaseViewModel {
  List<StreamController> controllers = [];

  ///
  /// this method execute future and add result in your controller
  void executeFuture<T>(Future<T> future,
      {BroadcastStream<T>? broadcastStream, StreamController<T>? controller}) {
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

  ///
  /// this method execute future and add result in your controller
  void executeUseCase<I, O>(UseCase<I, O> useCase, I params,
      {BroadcastStream<O>? broadcastStream, StreamController<O>? controller}) {
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

  /// This is a dispose method.
  ///
  /// Is called automatically if you use viewmodel with mixin, alternatively you can call manually
  ///
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
