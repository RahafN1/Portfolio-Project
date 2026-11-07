import 'dart:async';
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
  
  final Map<int, Timer> _saveTimers = {};
  final Map<int, bool> _savedOnServer = {};
  final Map<int, Timer> _completeTimers = {};
  final Map<int, bool> _completedOnServer = {};

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
    _savedOnServer.putIfAbsent(trail.id, () => isSaved(trail.id));

    if (isSaved(trail.id)) {
      saved.removeWhere((t) => t.id == trail.id);
    } else {
      saved.insert(0, trail);
    }
    notifyListeners();

    _saveTimers[trail.id]?.cancel();
    _saveTimers[trail.id] = Timer(
      const Duration(milliseconds: 500),
      () => _syncSaved(trail),
    );

    return true;
  }
  
  Future<void> _syncSaved(Trail trail) async {
    _saveTimers.remove(trail.id);
    final before = _savedOnServer.remove(trail.id) ?? false;
    final now = isSaved(trail.id);

    if (before == now) return;

    try {
      if (now) {
        await repository.addFavorite(trail.id);
      } else {
        await repository.removeFavorite(trail.id);
      }
    } catch (_) {
      if (before && !isSaved(trail.id)) {
        saved.insert(0, trail);
      } else if (!before) {
        saved.removeWhere((t) => t.id == trail.id);
      }
      notifyListeners();
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

    Future<bool> toggleCompleted(Trail trail) async {
    _completedOnServer.putIfAbsent(trail.id, () => isCompleted(trail.id));

    if (isCompleted(trail.id)) {
      completed.removeWhere((c) => c.trail.id == trail.id);
    } else {
      completed.insert(
        0,
        CompletedTrail(trail: trail, completedAt: DateTime.now()),
      );
    }
    notifyListeners();

    _completeTimers[trail.id]?.cancel();
    _completeTimers[trail.id] = Timer(
      const Duration(milliseconds: 500),
      () => _syncCompleted(trail),
    );

    return true;
  }
  
  Future<void> _syncCompleted(Trail trail) async {
    _completeTimers.remove(trail.id);
    final before = _completedOnServer.remove(trail.id) ?? false;
    final now = isCompleted(trail.id);

    if (before == now) return;

    try {
      if (now) {
        await repository.addCompleted(trail.id);
      } else {
        await repository.removeCompleted(trail.id);
      }
    } catch (_) {
      if (before && !isCompleted(trail.id)) {
        completed.insert(
          0,
          CompletedTrail(trail: trail, completedAt: DateTime.now()),
        );
      } else if (!before) {
        completed.removeWhere((c) => c.trail.id == trail.id);
      }
      notifyListeners();
    }
  }
  @override
  void dispose() {
    for (final timer in _saveTimers.values) {
      timer.cancel();
    }
    for (final timer in _completeTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
