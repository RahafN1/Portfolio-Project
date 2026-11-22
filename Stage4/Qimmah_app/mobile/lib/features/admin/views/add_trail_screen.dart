import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/storage/image_cache.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/l10n.dart';
import '../../trails/models/trail.dart';
import '../viewmodels/admin_viewmodel.dart';
import 'widgets/admin_helpers.dart';

// صفحة إضافة مسار جديد (أو تعديل مسار موجود لو انرسل لها trail)
class AddTrailScreen extends StatefulWidget {
  // null = إضافة، غير كذا = تعديل
  final Trail? trail;

  const AddTrailScreen({super.key, this.trail});

  @override
  State<AddTrailScreen> createState() => _AddTrailScreenState();
}

class _AddTrailScreenState extends State<AddTrailScreen> {
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _picker = ImagePicker();

  // صور المسار الحالية (روابط من السيرفر) — تظهر في التعديل بس
  final List<String> _existingImages = [];

  // الصور الجديدة اللي اخترتيها (بيانات بايتات عشان تشتغل على الجوال والويب)
  final List<Uint8List> _images = [];

  // المنطقة المختارة (null = ما اختارت شي للحين)
  String? _region;

  // الصعوبة المختارة (المتوسط محدد من البداية مثل التصميم)
  String _difficulty = 'moderate';

  // هل نرسل للسيرفر الحين؟ (عشان نعطل الزر ونطلع دائرة تحميل)
  bool _isSaving = false;

  // قائمة المناطق (عدليها لو تبين)
  static const List<String> _regions = [
    'الرياض',
    'مكة المكرمة',
    'المدينة المنورة',
    'القصيم',
    'الشرقية',
    'عسير',
    'تبوك',
    'حائل',
    'الحدود الشمالية',
    'جازان',
    'نجران',
    'الباحة',
    'الجوف',
  ];

  // اسم المنطقة المعروض (القيمة اللي تنرسل للسيرفر تبقى بالعربي)
  String _regionLabel(BuildContext context, String value) {
    final l10n = context.l10n;
    switch (value) {
      case 'الرياض':
        return l10n.adminRegionRiyadh;
      case 'مكة المكرمة':
        return l10n.adminRegionMakkah;
      case 'المدينة المنورة':
        return l10n.adminRegionMadinah;
      case 'القصيم':
        return l10n.adminRegionQassim;
      case 'الشرقية':
        return l10n.adminRegionEastern;
      case 'عسير':
        return l10n.adminRegionAsir;
      case 'تبوك':
        return l10n.adminRegionTabuk;
      case 'حائل':
        return l10n.adminRegionHail;
      case 'الحدود الشمالية':
        return l10n.adminRegionNorthernBorders;
      case 'جازان':
        return l10n.adminRegionJazan;
      case 'نجران':
        return l10n.adminRegionNajran;
      case 'الباحة':
        return l10n.adminRegionBaha;
      case 'الجوف':
        return l10n.adminRegionJawf;
      default:
        return value;
    }
  }

  // هل نحن في وضع التعديل؟
  bool get _isEdit => widget.trail != null;

  @override
  void initState() {
    super.initState();

    // لو تعديل: نعبي الحقول ببيانات المسار
    final trail = widget.trail;
    if (trail != null) {
      _nameArController.text = trail.name;
      _region = trail.region;
      _distanceController.text = trail.distanceText;
      _durationController.text = trail.estimatedDuration;
      _descriptionController.text = trail.description;
      _existingImages.addAll(trail.images);
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // اختيار صور من الاستوديو
  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage();
    if (files.isEmpty) return;
    final bytesList = await Future.wait(files.map((f) => f.readAsBytes()));
    if (!mounted) return;
    setState(() => _images.addAll(bytesList));
  }

  // نشر مسار جديد، أو حفظ تعديلات مسار موجود
  Future<void> _onPublish() async {
    final l10n = context.l10n;
    final nameAr = _nameArController.text.trim();
    final description = _descriptionController.text.trim();
    final duration = _durationController.text.trim();
    // replaceAll عشان لو انكتبت الفاصلة "،" أو "," بدل النقطة
    final distance = double.tryParse(
      _distanceController.text.trim().replaceAll(',', '.'),
    );

    // نتأكد إن الحقول المطلوبة معبية
    if (nameAr.isEmpty) {
      showAdminToast(context, l10n.adminEnterNameAr);
      return;
    }
    if (_region == null) {
      showAdminToast(context, l10n.adminChooseRegion);
      return;
    }
    if (distance == null || distance <= 0) {
      showAdminToast(context, l10n.adminEnterDistance);
      return;
    }
    if (duration.isEmpty) {
      showAdminToast(context, l10n.adminEnterDuration);
      return;
    }
    // النبذة إجبارية في الإضافة بس
    if (!_isEdit && description.isEmpty) {
      showAdminToast(context, l10n.adminEnterAbout);
      return;
    }

    // البيانات اللي نرسلها (بأسماء الحقول اللي يتوقعها السيرفر)
    final data = <String, dynamic>{
      'name': nameAr,
      'region': _region,
      'difficulty': _difficulty,
      'distance': distance,
      'estimated_duration': duration,
      // النبذة ما نرسلها فاضية، عشان ما نمسح النبذة القديمة في التعديل
      if (description.isNotEmpty) 'description': description,
    };

    setState(() => _isSaving = true);

    final vm = context.read<AdminViewModel>();
        final ok = _isEdit
        ? await vm.updateTrail(widget.trail!, data, images: _images)
        : await vm.addTrail(data, images: _images);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (ok) {
      showAdminToast(
        context,
        _isEdit ? l10n.changesSaved : l10n.adminTrailPublished,
      );
      Navigator.pop(context);
    } else {
      showAdminToast(context, l10n.adminSaveTrailFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    // قائمة المناطق: لو منطقة المسار مو في القائمة نضيفها عشان ما يطلع خطأ
    final regionItems = [..._regions];
    if (_region != null && !regionItems.contains(_region)) {
      regionItems.add(_region!);
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 72,
        leadingWidth: 64,
        // زر الرجوع (يمين في العربي)
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Center(
            child: _CircleButton(
              icon: Icons.chevron_left,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
        // الشعار مع اسم الصفحة
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo_mountains.png', height: 16),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.adminBrandLatin,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    width: 1.5,
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: AppColors.primary,
                  ),
                  Text(
                    context.l10n.adminBrandArabic,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _isEdit
                  ? context.l10n.adminEditTrailTitle
                  : context.l10n.adminAddTrailTitle,
              style: const TextStyle(fontSize: 11, color: AppColors.grey),
            ),
          ],
        ),
        // زر اللغة (يسار في العربي)، مثل صفحة البداية غير مفعل للحين
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'EN',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.language, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // صور المسار
          _FieldLabel(context.l10n.adminTrailImages),
          SizedBox(
            height: 84,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _AddImageButton(onTap: _pickImages),
                // الصور الحالية (من السيرفر)
                for (int i = 0; i < _existingImages.length; i++)
                  _ImageThumb(
                    image: CachedNetworkImageProvider(
  _existingImages[i],
  cacheManager: AppImageCache.instance,
),
                    onRemove: () =>
                        setState(() => _existingImages.removeAt(i)),
                  ),
                // الصور الجديدة (من الاستوديو)
                for (int i = 0; i < _images.length; i++)
                  _ImageThumb(
                    image: MemoryImage(_images[i]),
                    onRemove: () => setState(() => _images.removeAt(i)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _FieldLabel(context.l10n.adminTrailNameAr),
          TextField(
            controller: _nameArController,
            decoration:
                InputDecoration(hintText: context.l10n.adminTrailNameArHint),
          ),
          const SizedBox(height: 16),

          _FieldLabel(context.l10n.adminTrailNameEn),
          TextField(
            controller: _nameEnController,
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(hintText: 'Wadi Lajab Trail'),
          ),
          const SizedBox(height: 16),

          // المنطقة
          _FieldLabel(context.l10n.region),
          DropdownButtonFormField<String>(
            initialValue: _region,
            hint: Text(context.l10n.adminSelectRegionHint),
            items: regionItems
                .map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(_regionLabel(context, r)),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _region = value),
          ),
          const SizedBox(height: 16),

          // الصعوبة
          _FieldLabel(context.l10n.difficulty),
          Row(
            children: [
              Expanded(
                child: _DifficultyOption(
                  label: context.l10n.difficultyEasy,
                  color: Colors.green,
                  selected: _difficulty == 'easy',
                  onTap: () => setState(() => _difficulty = 'easy'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DifficultyOption(
                  label: context.l10n.difficultyModerate,
                  color: Colors.blue,
                  selected: _difficulty == 'moderate',
                  onTap: () => setState(() => _difficulty = 'moderate'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DifficultyOption(
                  label: context.l10n.difficultyHard,
                  color: Colors.deepOrange,
                  selected: _difficulty == 'hard',
                  onTap: () => setState(() => _difficulty = 'hard'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // المسافة والمدة جنب بعض
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(context.l10n.adminDistanceKm),
                    TextField(
                      controller: _distanceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: '6'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(context.l10n.adminDurationHours),
                    TextField(
                      controller: _durationController,
                      decoration: const InputDecoration(hintText: '2–3'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // نبذة عن المسار
          _FieldLabel(context.l10n.adminTrailAbout),
          TextField(
            controller: _descriptionController,
            minLines: 4,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: context.l10n.adminTrailAboutHint,
            ),
          ),
        ],
      ),
      // الأزرار ثابتة تحت
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  // أثناء الحفظ نعطل الزر عشان ما ينضغط مرتين
                  onPressed: _isSaving ? null : _onPublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isEdit
                          ? context.l10n.saveChanges
                          : context.l10n.adminPublishTrail),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(context.l10n.adminCancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// زر دائري صغير (للرجوع)
class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }
}

// زر إضافة صورة
class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_outlined, color: AppColors.primary),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminAddImage,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صورة مصغرة مع زر حذف (×): تقبل صورة من الإنترنت أو من الجهاز
class _ImageThumb extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback onRemove;

  const _ImageThumb({required this.image, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: SizedBox(
        width: 84,
        height: 84,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image(
                image: image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.terrain, color: AppColors.disabled),
                ),
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: InkWell(
                onTap: onRemove,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// زر اختيار الصعوبة (نقطة ملونة + نص)
class _DifficultyOption extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// عنوان صغير فوق كل حقل
class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}
