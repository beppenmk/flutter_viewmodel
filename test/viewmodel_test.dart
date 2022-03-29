import 'dart:async';

import 'package:flutter/material.dart';
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

  final int SUCCESS_RESULT = 12;
  final int FAIL_RESULT = 0;

  setUp(() {
    when(useCase.execute(true)).thenAnswer((_) async => SUCCESS_RESULT);
    when(useCase.execute(false)).thenAnswer((_) async => FAIL_RESULT);
    when(useCase.execute(0)).thenAnswer((_) async {
      throw (Exception());
    });
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
        expect(event, SUCCESS_RESULT);
      });

      await Future.delayed(Duration(milliseconds: 500));
      baseViewModel.dispose();
      expect(baseViewModel.controllers.length, 0);
    });

    test('execute UseCase  broadcastStream', () async {
      final BaseViewModel baseViewModel = BaseViewModel();
      final broadcastStream = BroadcastStream();

      baseViewModel.executeUseCase(useCase, false,
          broadcastStream: broadcastStream);
      expect(baseViewModel.controllers.length, 1);

      await broadcastStream.stream?.listen((event) {
        expect(event, FAIL_RESULT);
      });

      await Future.delayed(Duration(milliseconds: 500));
      baseViewModel.dispose();
      expect(baseViewModel.controllers.length, 0);
    });
  });

  group("Widget SnapshotBuilder ", () {
    final broadcastStream = BroadcastStream<int>();

    testWidgets(' default value', (WidgetTester tester) async {
      final BaseViewModel baseViewModel = BaseViewModel();

      await tester.pumpWidget(MaterialApp(
        home: SnapshotBuilder(
          broadcast: broadcastStream,
          initialData: 1,
          onData: (value) => Text("Result is ${value}"),
          onError: (e) => Text("Error"),
        ),
      ));
      expect(find.text('Result is 1'), findsOneWidget);
    });

    testWidgets(' positive value', (WidgetTester tester) async {
      final BaseViewModel baseViewModel = BaseViewModel();

      await tester.pumpWidget(MaterialApp(
        home: SnapshotBuilder(
          broadcast: broadcastStream,
          initialData: 1,
          onData: (value) => Text("Result is ${value}"),
          onError: (e) => Text("Error"),
        ),
      ));
      baseViewModel.executeUseCase(useCase, true,
          broadcastStream: broadcastStream);
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Result is ${SUCCESS_RESULT}'), findsOneWidget);
    });

    testWidgets(' negative value', (WidgetTester tester) async {
      final BaseViewModel baseViewModel = BaseViewModel();

      await tester.pumpWidget(MaterialApp(
        home: SnapshotBuilder(
          broadcast: broadcastStream,
          initialData: 1,
          onData: (value) => Text("Result is ${value}"),
          onError: (e) => Text("Error"),
        ),
      ));
      baseViewModel.executeUseCase(useCase, false,
          broadcastStream: broadcastStream);
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Result is ${FAIL_RESULT}'), findsOneWidget);
    });

    testWidgets(' onError', (WidgetTester tester) async {
      final BaseViewModel baseViewModel = BaseViewModel();

      await tester.pumpWidget(MaterialApp(
        home: SnapshotBuilder(
          broadcast: broadcastStream,
          initialData: 1,
          onData: (value) => Text("Result is ${value}"),
          onError: (e) => Text("Error"),
        ),
      ));
      baseViewModel.executeUseCase(useCase, 0,
          broadcastStream: broadcastStream);
      await tester.pump(Duration(seconds: 1));
      expect(find.text('Error'), findsOneWidget);
    });
  });
}
