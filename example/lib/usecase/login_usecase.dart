

import 'package:flutter_vm/base/usecase.dart';

import '../repository/user_repository.dart';

class LoginUseCase  extends UseCase<LoginParams, bool>{
  final UserRepository _userRepository;

  LoginUseCase(this._userRepository);


  @override
  Future<bool> execute(LoginParams params)async  {
    await  _userRepository.login();
    return   _userRepository.getIfUserIsLogged();
  }

}

class LoginParams {
  final String _username;
  final String _password;

  LoginParams(this._username, this._password);
}