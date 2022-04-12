# ViewModel Library


A Flutter ViewModel implementation. Use Mixin for use in Statefull Widget or sample contructor for use in Stateless.

In your **CustomViewModel** you can use **UseCase** or custom **Future**.

In your Widget you can listen your stream or use **SnapshotBuilder** in your build method.

You can see a full example at this repo.
[Flutter ViewModel Example](https://github.com/beppenmk/flutter_viewmodel_example)  


## ViewModel
```
class AuthViewModel extends BaseViewModel {
   
  final LogoutUseCase _logoutUseCase = LoginUseCase();
     
   

	//you can listen this in your UI 
  final isUserLogged = BroadcastStream<bool>();

  void login() {
    executeUseCase(_loginUseCase, LoginParams("username", "password"),
        broadcastStream: isUserLogged);
  }

 
}
```
## UseCase
```
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
```

## Init in StateFull Widget
```
class _LoginMixinWidgetState extends State<LoginMixinWidget>
    with ViewModel<LoginMixinWidget, AuthViewModel> { //use mixin


  @override
  AuthViewModel getViewModel() => AuthViewModel(); // need constructor

  @override
  void initState() {
    super.initState();
    // now you can access to ViewModel with vm
    vm.getIfUserIsLogged();  
  }
  
```

## Init in StateLess Widget

```
 class _LoginWidgetState extends State<LoginWidget> {
  AuthViewModel _authViewModel = AuthViewModel(); //basic init

  @override
  void initState() {
    _authViewModel.getIfUserIsLogged();

    super.initState();
  }

  @override
  void dispose() {
    _authViewModel.dispose();// you need to dispose
    super.dispose();
  }
```

## Use SnapshotBuilder
```
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SnapshotBuilder<bool>(//need to specify data type
          initialData: false,
          broadcast: _authViewModel.isUserLogged, //broadcast in viu model you listen
          onLoading: Container(), 
          onError: (e) {
          //here you have error
            return Container();
          },
          onData: (value) {
          //here you have data
            return Container();
          },
        ),
      ),
    );
  }
  
```
## Listen Strem 
```
  int _counter = 0;
  
  @override
  void initState() {
    vm.number.stream?.listen((value) {
      setState(() {
        _counter = value;
      });
    });

    super.initState();
  }
  
```
