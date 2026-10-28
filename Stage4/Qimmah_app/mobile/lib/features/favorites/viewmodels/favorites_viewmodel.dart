import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../../trails/models/trail.dart';
import '../data/favorites_repository.dart';
import '../models/completed_trail.dart';

enum MyTrailsTab { saved, completed }

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository repository;

  FavoritesViewModel(this.repository);

  List<Trail> saved = [];
  List<CompletedTrail> completed = [];
  MyTrailsTab tab = MyTrailsTab.saved;
  bool isLoading = false;
  String? errorMessage;

  void setTab(MyTrailsTab value) {
    tab = value;
    notifyListeners();
  }

  // مجموع المسافات المكتملة (للشريط الأخضر)
  double get completedDistance =>
      completed.fold(0, (sum, c) => sum + c.trail.distance);

  bool isSaved(int id) => saved.any((t) => t.id == id);

  bool isCompleted(int id) => completed.any((c) => c.trail.id == id);

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    // المحفوظة
    try {
      saved = await repository.getFavorites();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'ما قدرنا نجيب مساراتك';
    }

    // المكتملة: لو فشلت ما نخرّب الشاشة كلها
    try {
      completed = await repository.getCompletedTrails();
    } catch (_) {
      completed = [];
    }

    isLoading = false;
    notifyListeners();
  }

  // حفظ أو إلغاء حفظ (من الاستكشاف أو التفاصيل). يرجّع true لو نجح
  // نغيّر القائمة فوراً، ونرجّعها لو فشل الطلب
  Future<bool> toggleSaved(Trail trail) async {
    if (isSaved(trail.id)) return removeSaved(trail);

    saved.insert(0, trail);
    notifyListeners();

    try {
      await repository.addFavorite(trail.id);
      return true;
    } catch (_) {
      saved.removeWhere((t) => t.id == trail.id);
      notifyListeners();
      return false;
    }
  }

  // إلغاء الحفظ. يرجّع true لو نجح
  Future<bool> removeSaved(Trail trail) async {
    final index = saved.indexWhere((t) => t.id == trail.id);
    if (index == -1) return true;

    saved.removeAt(index);
    notifyListeners();

    try {
      await repository.removeFavorite(trail.id);
      return true;
    } catch (_) {
      saved.insert(index, trail);
      notifyListeners();
      return false;
    }
  }

  // تسجيل المسار كمكتمل أو إلغاؤه. يرجّع true لو نجح
  Future<bool> toggleCompleted(Trail trail) async {
    final index = completed.indexWhere((c) => c.trail.id == trail.id);

    // إلغاء الإكمال
    if (index != -1) {
      final removed = completed.removeAt(index);
      notifyListeners();
      try {
        await repository.removeCompleted(trail.id);
        return true;
      } catch (_) {
        completed.insert(index, removed);
        notifyListeners();
        return false;
      }
    }

    // تسجيل الإكمال (التاريخ المؤقت لين نعيد تحميل القائمة)
    completed.insert(
      0,
      CompletedTrail(trail: trail, completedAt: DateTime.now()),
    );
    notifyListeners();
    try {
      await repository.addCompleted(trail.id);
      return true;
    } catch (_) {
      completed.removeWhere((c) => c.trail.id == trail.id);
      notifyListeners();
      return false;
    }
  }
}