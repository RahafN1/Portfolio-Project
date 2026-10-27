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

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // الطلبين مع بعض
      final results = await Future.wait([
        repository.getFavorites(),
        repository.getCompletedTrails(),
      ]);
      saved = results[0] as List<Trail>;
      completed = results[1] as List<CompletedTrail>;
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'ما قدرنا نجيب مساراتك';
    }

    isLoading = false;
    notifyListeners();
  }
  bool isSaved(int id) => saved.any((t) => t.id == id);

  // حفظ أو إلغاء حفظ (من الاستكشاف). يرجّع true لو نجح
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
  // إلغاء الحفظ: نشيله من القائمة أول، ونرجّعه لو فشل الطلب
  // يرجّع true لو نجح
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
}