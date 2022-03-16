library viewmodel;

import 'dart:async';

import 'package:viewmodel/usecase.dart';

import 'broadcast_stream_controller.dart';


class ViewModel {
  List<StreamController> controllers = [];

  void executeFuture<T>(Future<T>? future,
      {BroadcastStream<T>? broadcastStreamController,
      StreamController<T>? controller}) {
    //CHECK INPUT (ONE SOURCE AND ONE DESTINATION)
    if (future == null) {
      print("Future and usecase must be not null");
      return;
    }
    if ((broadcastStreamController == null && controller == null) ||
        (broadcastStreamController != null && controller != null)) {
      print(
          "One (and only one) between broadcastStreamController and controller must be not null");
      return;
    }

    //ADD ONE OF THE TWO CONTROLLERS
    var _controller;
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
    if (params == null) {
      print("Usecase and params must be not null");
      return;
    }
    if ((broadcastStreamController == null && controller == null) ||
        (broadcastStreamController != null && controller != null)) {
      print(
          "One (and only one) between broadcastStreamController and controller must be not null");
      return;
    }

    //ADD ONE OF THE TWO CONTROLLERS
    var _controller;
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
    print("Disposed ${controllers.length} controllers");
  }
}
