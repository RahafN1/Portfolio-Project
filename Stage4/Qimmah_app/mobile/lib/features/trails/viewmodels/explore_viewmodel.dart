import 'package:flutter/material.dart';

import '../data/trails_repository.dart';
import '../models/trail.dart';

class ExploreViewModel extends ChangeNotifier {
  final TrailsRepository repository;

  ExploreViewModel(this.repository);

  static const String allRegions = 'كل المناطق';
  static const int featuredCount = 5;

  List<Trail> _all = [];
  bool isLoading = false;
  String? errorMessage;

  // الفلاتر الحالية
  String searchQuery = '';
  String? selectedDifficulty; // null = الكل
  String selectedRegion = allRegions;

  // المسارات المحفوظة (مؤقتاً بالذاكرة، نربطها بالمفضلة بعدين)
  final Set<int> savedIds = {};

  Future<void> loadTrails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _all = await repository.getTrails();
    } catch (e) {
      errorMessage = 'ما قدرنا نجيب المسارات';
    }

    isLoading = false;
    notifyListeners();
  }

  // أسماء المناطق الموجودة فعلاً بالبيانات
  List<String> get regions {
    final names = _all.map((t) => t.region).where((r) => r.isNotEmpty).toSet();
    return [allRegions, ...names];
  }

  // المسارات بعد البحث والفلترة
  List<Trail> get filtered {
    return _all.where((t) {
      final matchSearch =
          searchQuery.isEmpty || t.name.contains(searchQuery.trim());
      final matchDifficulty =
          selectedDifficulty == null || t.difficulty == selectedDifficulty;
      final matchRegion =
          selectedRegion == allRegions || t.region == selectedRegion;
      return matchSearch && matchDifficulty && matchRegion;
    }).toList();
  }

  // مختارة = أول ٥ مسارات، والباقي تحت "مسارات أخرى"
  List<Trail> get featured => filtered.take(featuredCount).toList();
  List<Trail> get others => filtered.skip(featuredCount).toList();

  bool get hasActiveFilters =>
      selectedDifficulty != null || selectedRegion != allRegions;

  void setSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setDifficulty(String? value) {
    selectedDifficulty = value;
    notifyListeners();
  }

  void setRegion(String value) {
    selectedRegion = value;
    notifyListeners();
  }

  void resetFilters() {
    selectedDifficulty = null;
    selectedRegion = allRegions;
    notifyListeners();
  }

  bool isSaved(int id) => savedIds.contains(id);

  void toggleSaved(int id) {
    if (!savedIds.remove(id)) savedIds.add(id);
    notifyListeners();
  }
}
