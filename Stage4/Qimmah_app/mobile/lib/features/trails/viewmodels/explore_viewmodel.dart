import 'package:flutter/material.dart';

import '../data/trails_repository.dart';
import '../models/trail.dart';

class ExploreViewModel extends ChangeNotifier {
  final TrailsRepository repository;

  ExploreViewModel(this.repository);

  List<Trail> trails = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTrails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      trails = await repository.getTrails();
    } catch (e) {
      errorMessage = 'ما قدرنا نجيب المسارات';
    }

    isLoading = false;
    notifyListeners();
  }
}
