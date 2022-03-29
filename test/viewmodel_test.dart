import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:viewmodel/vm.dart';

import 'mock/usecase_mock.dart';

void main() {
  test('adds one to input values', () {
    //final calculator = Calculator();
    //expect(calculator.addOne(2), 3);
    //expect(calculator.addOne(-7), -6);
    //expect(calculator.addOne(0), 1);
  });

  group('BaseViewModel', () {

    test('init', () {
      final BaseViewModel baseViewModel = BaseViewModel();
      expect(baseViewModel.controllers.length, 0);
    });

    test('execute future', () async {
      final BaseViewModel baseViewModel = BaseViewModel();
      final f = Future.value();
      final broadcastStream = BroadcastStream();
      final controller = StreamController();

      expect(() {
        baseViewModel.executeFuture(f);
        assert(false);
      }, throwsAssertionError);
      expect(baseViewModel.controllers.length, 0);

      expect(() {
        baseViewModel.executeFuture(f,
            broadcastStream: broadcastStream, controller: controller);
        assert(false);
      }, throwsAssertionError);
      expect(baseViewModel.controllers.length, 0);


      baseViewModel.executeFuture(f, controller: controller);
      expect(baseViewModel.controllers.length, 1);

      baseViewModel.executeFuture(f, broadcastStream: broadcastStream);
      expect(baseViewModel.controllers.length, 2);
      await Future.delayed(Duration(milliseconds: 500));

      baseViewModel.dispose();
      expect(baseViewModel.controllers.length, 0);
    });

    test('execute UseCase fail', () async {
      final BaseViewModel baseViewModel = BaseViewModel();
      final broadcastStream = BroadcastStream();
      final controller = StreamController();
      final  useCase = FakeUseCase();

      expect(() {
        baseViewModel.executeUseCase(useCase, NoParams());
        assert(false);
      }, throwsAssertionError);
      expect(baseViewModel.controllers.length, 0);
      expect(() {
        baseViewModel.executeUseCase(useCase, NoParams(),
            broadcastStream: broadcastStream, controller: controller);
        assert(false);
      }, throwsAssertionError);
      expect(baseViewModel.controllers.length, 0);

    });

    test('execute UseCase  controller', () async {
      final BaseViewModel baseViewModel = BaseViewModel();
      final controller = StreamController();
      final  useCase = FakeUseCase();

      baseViewModel.executeUseCase(useCase, NoParams(),  controller: controller ) ;
      expect(baseViewModel.controllers.length, 1);

      await controller.stream.listen((event) {
        expect(event, true);
      });

      await Future.delayed(Duration(milliseconds: 500));
      baseViewModel.dispose();
      expect(baseViewModel.controllers.length, 0);

    });

    test('execute UseCase  broadcastStream', () async {
      final BaseViewModel baseViewModel = BaseViewModel();
      final broadcastStream = BroadcastStream();
      final  useCase = FakeUseCase();

      baseViewModel.executeUseCase(useCase, NoParams(),  broadcastStream: broadcastStream ) ;
      expect(baseViewModel.controllers.length, 1);

      await broadcastStream.stream?.listen((event) {
        expect(event, true);
      });

      await Future.delayed(Duration(milliseconds: 500));
      baseViewModel.dispose();
      expect(baseViewModel.controllers.length, 0);

    });

  });
}
