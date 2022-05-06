abstract class UseCase<I, O> {
  Future<O> execute(I params);
}

class NoParams {}
