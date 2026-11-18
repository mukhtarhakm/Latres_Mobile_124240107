import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const studentNim = '124240107';

class SessionController extends GetxController {
  SessionController(this.prefs);

  final SharedPreferences prefs;
  final RxnString username = RxnString();

  @override
  void onInit() {
    username.value = prefs.getString('username');
    super.onInit();
  }

  Future<bool> login(String inputNim, String password) async {
    if (inputNim.trim() != studentNim || password != '123') return false;
    await prefs.setString('username', studentNim);
    username.value = studentNim;
    return true;
  }

  Future<void> logout() async {
    await prefs.remove('username');
    username.value = null;
  }
}
