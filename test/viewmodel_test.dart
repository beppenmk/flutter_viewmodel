import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:viewmodel/vm.dart';
import 'viewmodel_test.mocks.dart';

@GenerateMocks([
  UseCase,
], customMocks: [])


void main() {

  final useCase = MockUseCase();
  final f = Future.value();

  setUp(() {
    when(useCase.execute(true)).thenAnswer((_) async => true);
    when(useCase.execute(false)).thenAnswer((_) async => false);
  });


  group('BaseViewModel', () {
    test('init', () {
      final BaseViewModel baseViewModel = BaseViewModel();
      expect(baseViewModel.controllers.length, 0);
    });

    test('execute future', () async {
      final BaseViewModel baseViewModel = BaseViewModel();
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
      baseViewModel.executeUseCase(useCase, true, controller: controller);
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

      baseViewModel.executeUseCase(useCase,false,
          broadcastStream: broadcastStream);
      expect(baseViewModel.controllers.length, 1);

      await broadcastStream.stream?.listen((event) {
        expect(event, false);
      });

      await Future.delayed(Duration(milliseconds: 500));
      baseViewModel.dispose();
      expect(baseViewModel.controllers.length, 0);
    });
  });
}
