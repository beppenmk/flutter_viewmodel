import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vm/vm.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginMixinWidget extends StatefulWidget {
  const LoginMixinWidget({Key? key}) : super(key: key);
  @override
  State<LoginMixinWidget> createState() => _LoginMixinWidgetState();
}

class _LoginMixinWidgetState extends State<LoginMixinWidget>
    with ViewModel<LoginMixinWidget, AuthViewModel> {

  @override
  AuthViewModel getViewModel() => AuthViewModel();

  @override
  void initState() {
    super.initState();
    vm.getIfUserIsLogged();
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
          broadcast: vm.isUserLogged,
          onData: (value) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(" User is logged : ${value}"),
                  if (value)
                    ElevatedButton(
                      onPressed: () {
                        vm.logout();
                      },
                      child: const Text('Logout'),
                    ),
                  if (!value)
                    ElevatedButton(
                      onPressed: () {
                        vm.login();
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
