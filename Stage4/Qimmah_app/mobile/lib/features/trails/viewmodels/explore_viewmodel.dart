import 'package:flutter/material.dart';

import '../data/trails_repository.dart';
import '../models/trail.dart';
import 'dart:async';//عشان نستخدم Timer في البحث

class ExploreViewModel extends ChangeNotifier {
  final TrailsRepository repository;

  ExploreViewModel(this.repository);

  static const String allRegions = 'كل المناطق';
  // كم مسار نجيب بكل مرة
static const int pageSize = 10;

 // ---------- قائمة الاستكشاف (صفحات) ----------
final List<Trail> _trails = [];
int _page = 0; // آخر صفحة انجلبت
int total = 0; // إجمالي المسارات اللي تطابق الفلاتر (من الباك إند)

bool isLoading = false; // تحميل أول صفحة
bool isLoadingMore = false; // تحميل صفحة إضافية
String? errorMessage; // خطأ تحميل أول صفحة
String? loadMoreError; // خطأ تحميل صفحة إضافية

// رقم الطلب: لو تغيّرت الفلاتر نتجاهل رد الطلب القديم
int _requestId = 0;
Timer? _searchDebounce;

  // الفلاتر الحالية
  String searchQuery = '';
  String? selectedDifficulty; // null = الكل
  String selectedRegion = allRegions;

  // المسارات المحفوظة (مؤقتاً بالذاكرة، نربطها بالمفضلة بعدين)
    final Set<int> savedIds = {};

  // ---------- الخريطة: كل المسارات مرة وحدة ----------
      List<Trail> _mapAll = [];

// المناطق اللي عرفناها لين الحين (تتجمّع وما تنحذف)
    final Set<String> _knownRegions = {};

      List<Trail> get trails => List.unmodifiable(_trails);

      bool get hasMore => _trails.length < total;

    String? get _regionParam =>
      selectedRegion == allRegions ? null : selectedRegion;

// يجيب أول صفحة (عند فتح الشاشة، تغيير الفلاتر، والسحب للتحديث)
Future<void> loadTrails() async {
  final id = ++_requestId;
  isLoading = true;
  isLoadingMore = false;
  errorMessage = null;
  loadMoreError = null;
  notifyListeners();

  try {
    final result = await repository.getTrails(
      page: 1,
      limit: pageSize,
      search: searchQuery,
      region: _regionParam,
      difficulty: selectedDifficulty,
    );
    if (id != _requestId) return; // فيه طلب أحدث، نتجاهل هذا
    _trails
      ..clear()
      ..addAll(result.trails);
    _page = 1;
    total = result.total;
    _rememberRegions(result.trails);
  } catch (e) {
    if (id != _requestId) return;
    errorMessage = 'ما قدرنا نجيب المسارات';
  }

  isLoading = false;
  notifyListeners();
}

// يجيب الصفحة اللي بعدها (لما اليوزر ينزل لآخر القائمة)
Future<void> loadMore() async {
  if (isLoading || isLoadingMore || !hasMore) return;
//دايماً يبدأ من صفحة 1 ويمسح القائمة. loadMore
  final id = _requestId;
  isLoadingMore = true;
  loadMoreError = null;
  notifyListeners();
//_requestId يحمي من مشكلة: تفتحين فلتر "سهل" وبعدها "صعب" بسرعة. رد "سهل" لو وصل متأخر بيخرب القائمة، فنتجاهله لأن رقمه قديم.
  try {
    final result = await repository.getTrails(
      page: _page + 1,
      limit: pageSize,
      search: searchQuery,
      region: _regionParam,
      difficulty: selectedDifficulty,
    );
    if (id != _requestId) return; // الفلاتر تغيّرت وإحنا نحمّل
    final existing = _trails.map((t) => t.id).toSet();
    _trails.addAll(result.trails.where((t) => !existing.contains(t.id)));//شرط existing يمنع تكرار نفس المسار لو تغيّرت البيانات بين الصفحتين.
    _page = result.page;
    total = result.total;
    _rememberRegions(result.trails);
  } catch (e) {
    if (id != _requestId) return;
    loadMoreError = 'ما قدرنا نحمّل المزيد';
  }

  isLoadingMore = false;
  notifyListeners();
}

void _rememberRegions(List<Trail> list) {
  _knownRegions.addAll(list.map((t) => t.region).where((r) => r.isNotEmpty));
}

// أسماء المناطق اللي عرفناها
List<String> get regions {
  final names = {
    ..._knownRegions,
    ..._mapAll.map((t) => t.region).where((r) => r.isNotEmpty),
  }.toList()
    ..sort();
  return [allRegions, ...names];
}

  bool get hasActiveFilters =>
      selectedDifficulty != null || selectedRegion != allRegions;

 // البحث: ننتظر 1000 ملي ثانية بعد آخر حرف عشان ما نرسل طلب مع كل حرف
void setSearch(String value) {
  searchQuery = value;
  _searchDebounce?.cancel();
  _searchDebounce = Timer(const Duration(milliseconds: 1000), loadTrails);
  notifyListeners();
}

void setDifficulty(String? value) {
  if (selectedDifficulty == value) return;
  selectedDifficulty = value;
  loadTrails();
}

void setRegion(String value) {
  if (selectedRegion == value) return;
  selectedRegion = value;
  loadTrails();
}

void resetFilters() {
  selectedDifficulty = null;
  selectedRegion = allRegions;
  loadTrails();
}

  bool isSaved(int id) => savedIds.contains(id);

  void toggleSaved(int id) {
    if (!savedIds.remove(id)) savedIds.add(id);
    notifyListeners();
  }
  // ---------- الخريطة ----------
// الخريطة تحتاج كل العلامات، فنجيبها مرة وحدة (أقصى حد ١٠٠)
Future<void> loadMapTrails() async {
  if (_mapAll.isNotEmpty) return;
  try {
    final result = await repository.getTrails(page: 1, limit: 100);
    _mapAll = result.trails;
    notifyListeners();
  } catch (_) {
    // لو فشل، الخريطة تظهر فاضية وتعيد المحاولة المرة الجاية
  }
}
// تفاصيل مسار واحد (فيها خط المسار)، نحتاجها لما نضغط علامة في الخريطة
Future<Trail> loadTrailDetails(int id) => repository.getTrail(id);

// مسارات الخريطة بعد تطبيق نفس فلاتر الاستكشاف
List<Trail> get mapTrails {
  return _mapAll.where((t) {
    final matchSearch =
        searchQuery.trim().isEmpty || t.name.contains(searchQuery.trim());
    final matchDifficulty =
        selectedDifficulty == null || t.difficulty == selectedDifficulty;
    final matchRegion =
        selectedRegion == allRegions || t.region == selectedRegion;
    return matchSearch && matchDifficulty && matchRegion;
  }).toList();
}

@override
void dispose() {
  _searchDebounce?.cancel();
  super.dispose();
}
/*
الخريطة لازم تعرض كل الدبابيس، مو أول 10 بس.
 فهي تجيب كل شي مرة وحدة وتفلتر محلياً (هنا الفلترة المحلية مناسبة).
*/
}
