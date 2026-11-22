import 'package:flutter/foundation.dart';

import '../../../core/network/api_exception.dart';
import '../../../l10n/l10n.dart';
import '../data/auth_repository.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository);

  User? user; // المستخدم الحالي
  bool isLoading = false;
  String? errorMessage;
  String? emailToVerify; // نحتاجه في شاشة الرمز
  String? emailToReset; // الإيميل في مسار نسيت كلمة المرور
  // نرجع true إذا اليوزر ضيف أو ما سجّل دخول أصلاً
  bool get isGuest => user == null || user!.role == 'guest';
  // هل المستخدم أدمن؟ (من الدور اللي يرجعه السيرفر، مو من الإيميل)
  bool get isAdmin => user != null && user!.role == 'admin';

  Future<bool> checkSavedLogin() async {
    user = await repository.getSavedUser();
    notifyListeners();
    return user != null;
  }

  Future<bool> register(String name, String email, String password) async {
    _startLoading();
    try {
      await repository.register(name, email, password);
      emailToVerify = email;
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  Future<bool> verifyEmail(String code) async {
    _startLoading();
    try {
      user = await repository.verifyEmail(emailToVerify!, code);
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  Future<bool> resendCode() async {
    _startLoading();
    try {
      await repository.resendCode(emailToVerify!);
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }
  Future<bool> forgotPassword(String email) async {
    _startLoading();
    try {
      await repository.forgotPassword(email);
      emailToReset = email;
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  Future<bool> resetPassword(String code, String newPassword) async {
    _startLoading();
    try {
      await repository.resetPassword(emailToReset!, code, newPassword);
      emailToReset = null;
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }
  Future<bool> login(String email, String password) async {
    _startLoading();
    try {
      user = await repository.login(email, password);
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  // تعديل الاسم: نرسله للباك ونحدّث المستخدم الحالي
  Future<bool> updateName(String name) async {
    _startLoading();
    try {
      user = await repository.updateName(name);
      _stopLoading();
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  // الضيف ما يكلم السيرفر، بس نعطيه اسم "ضيف"
  void loginAsGuest() {
    user = User(id: 0, name: L10n.tr.authGuestName, email: '', role: 'guest');
    notifyListeners();
  }

  Future<void> logout() async {
    await repository.logout();
    user = null;
    notifyListeners();
  }

  // تنادى من ApiClient لما تنتهي الجلسة.
  // التوكن انمسح هناك، فهنا نصفّر حالة المستخدم بس (بدون طلب للسيرفر)
  void handleSessionExpired() {
    user = null;
    isLoading = false;
    errorMessage = null;
    emailToVerify = null;
    notifyListeners();
  }

  void _startLoading() {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void _showError(Object e) {
    if (kDebugMode) debugPrint('AuthViewModel error: $e');

    if (e is ApiException) {
      errorMessage = e.message;
    } else {
      errorMessage = L10n.tr.authCheckConnection;
    }
    isLoading = false;
    notifyListeners();
  }
}