import 'package:flutter_vm/base/usecase.dart';

import '../repository/user_repository.dart';

class LogoutUseCase extends UseCase<NoParams, bool> {
  final UserRepository _userRepository;

  LogoutUseCase(this._userRepository);

  @override
  Future<bool> execute(NoParams params) async {
    await _userRepository.logout();
    return _userRepository.getIfUserIsLogged();
  }
}
