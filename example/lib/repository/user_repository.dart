class UserRepository {
  //SharedPreferences? _prefs;
  final String USER = "USER";
/*
  Future<SharedPreferences> _getPref() async {
    _prefs ??= await SharedPreferences.getInstance();
    return Future.value(_prefs);
  }
*/
  Future<bool> getIfUserIsLogged() async {
    // final prefs = await _getPref();
    // String? _token = prefs.getString(USER);
    return Future.value(true);
  }

  Future<bool> login() async {
    //final prefs = await _getPref();
    //prefs.setString(USER, "token");
    //String? _token = prefs.getString(USER);
    return Future.value(true);
  }

  Future<bool> logout() async {
    //final prefs = await _getPref();
    //prefs.clear();
    //String? _token = prefs.getString(USER);
    return Future.value(false);
  }
}
