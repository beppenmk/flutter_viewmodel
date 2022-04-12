import 'package:flutter_vm/base/usecase.dart';
import '../repository/user_repository.dart';

class IsUserLoggedUseCase  extends UseCase<NoParams, bool>{
  final UserRepository _userRepository;

  IsUserLoggedUseCase(this._userRepository);


  @override
  Future<bool> execute(NoParams params ) {
    return _userRepository.getIfUserIsLogged();
  }

}