import 'package:flutter_vm/vm.dart';

import '../repository/user_repository.dart';
import '../usecase/is_user_logged_usecase.dart';
import '../usecase/login_usecase.dart';
import '../usecase/logout_usecase.dart';

class AuthViewModel extends BaseViewModel {
  late IsUserLoggedUseCase _isUserLoggedUseCase;
  late LoginUseCase _loginUseCase;
  late LogoutUseCase _logoutUseCase;

  AuthViewModel() {
    final UserRepository _userRepository = UserRepository();
    _isUserLoggedUseCase = IsUserLoggedUseCase(_userRepository);
    _loginUseCase = LoginUseCase(_userRepository);
    _logoutUseCase = LogoutUseCase(_userRepository);
  }

  final isUserLogged = BroadcastStream<bool>();

  void getIfUserIsLogged() {
    executeUseCase(_isUserLoggedUseCase, NoParams(),
        broadcastStream: isUserLogged);
  }

  void login() {
    executeUseCase(_loginUseCase, LoginParams("username", "password"),
        broadcastStream: isUserLogged);
  }

  void logout() {
    executeUseCase(_logoutUseCase, NoParams(), broadcastStream: isUserLogged);
  }
}
