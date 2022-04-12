import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vm/vm.dart';

import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/countdown_viewmodel.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  AuthViewModel _authViewModel = AuthViewModel();

  @override
  void initState() {
    _authViewModel.getIfUserIsLogged();

    super.initState();
  }

  @override
  void dispose() {
    _authViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login UseCase"),
      ),
      body: Center(
        child: SnapshotBuilder<bool>(
          initialData: false,
          broadcast: _authViewModel.isUserLogged,
          onData: (value) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(" User is logged : ${value}"),
                  if (value)
                    ElevatedButton(
                      onPressed: () {
                        _authViewModel.logout();
                      },
                      child: const Text('Logout'),
                    ),
                  if (!value)
                    ElevatedButton(
                      onPressed: () {
                        _authViewModel.login();
                      },
                      child: const Text('Login'),
                    ),
                ]);
          },
        ),
      ),
    );
  }
}
