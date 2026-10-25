import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repository;

  AuthViewModel(this.repository);

  User? user; // المستخدم الحالي
  bool isLoading = false;
  String? errorMessage;
  String? emailToVerify; // نحتاجه في شاشة الرمز

  // نرجع true إذا اليوزر ضيف أو ما سجّل دخول أصلاً
  bool get isGuest => user == null || user!.role == 'guest';

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

  // الضيف ما يكلم السيرفر، بس نعطيه اسم "ضيف"
  void loginAsGuest() {
    user = User(id: 0, name: 'ضيف', email: '', role: 'guest');
    notifyListeners();
  }

  Future<void> logout() async {
    await repository.logout();
    user = null;
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
  print("الخطأ الحقيقي الذي حدث هو: $e"); // تجربه  هذا السطر
  
  if (e is ApiException) {
    errorMessage = e.message; 
  } else {
    errorMessage = 'تأكد من اتصالك بالإنترنت';
  }
  isLoading = false;
  notifyListeners();
}
}