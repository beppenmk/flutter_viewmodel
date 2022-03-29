 import 'package:flutter_test/flutter_test.dart';
import 'package:viewmodel/base/usecase.dart';

class FakeUseCase extends Fake implements UseCase {


  @override
  Future execute(params) {
     return Future.value(true);
  }
}