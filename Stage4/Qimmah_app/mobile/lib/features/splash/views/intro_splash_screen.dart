import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import 'splash_screen.dart';

/// أول شاشة تفتح: الجبل يترسم، وبعدها:
/// - لو فيه حساب محفوظ → يدخل على طول (الرئيسية، أو لوحة الأدمن)
/// - لو بدون حساب → يفتح سبلاش الترحيب (اللي فيها ابدأ الاستكشاف وتسجيل الدخول)
class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen>
    with SingleTickerProviderStateMixin {
  static const String _logoImage = 'assets/images/logo_mountains.png';

  late final AnimationController _controller;
  late final Animation<double> _draw; // رسم خط الجبل
  late final Animation<double> _fill; // ظهور الشعار الحقيقي فوق الخط
  late final Animation<double> _text; // ظهور كلمة Qimmah | قمّة

  Future<bool>? _loginCheck;
  bool _started = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    _draw = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.60, curve: Curves.easeInOutCubic),
    );
    _fill = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.80, curve: Curves.easeOut),
    );
    _text = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) _goNext();
    });

    // نتحقق من الحساب المحفوظ بالتوازي مع الأنيميشن
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loginCheck = _checkLogin();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // تحميل الصور مسبقاً عشان ما تومض لما تظهر
    precacheImage(const AssetImage(_logoImage), context);
    precacheImage(const AssetImage(SplashScreen.heroImage), context);

    if (_started) return;
    _started = true;

    // احترام إعداد "تقليل الحركة": نعرض الشعار مباشرة بدون رسم
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1;
      Future.delayed(const Duration(milliseconds: 600), _goNext);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _checkLogin() async {
    try {
      return await context.read<AuthViewModel>().checkSavedLogin();
    } catch (_) {
      // لو صار خطأ في قراءة التخزين نعتبره غير مسجّل
      return false;
    }
  }

  Future<void> _goNext() async {
    if (_navigated || !mounted) return;
    _navigated = true;

    final hasLogin = await (_loginCheck ?? _checkLogin());
    if (!mounted) return;

    final isAdmin = context.read<AuthViewModel>().isAdmin;
    final navigator = Navigator.of(context);

    if (hasLogin) {
      if (isAdmin) {
        // الأدمن يروح للوحة التحكم
        navigator.pushNamedAndRemoveUntil(AppRouter.admin, (route) => false);
      } else {
        // المستخدم العادي يروح للرئيسية
        navigator.pushReplacementNamed(AppRouter.explore);
      }
    } else {
      // بدون حساب: سبلاش الترحيب بتلاشي ناعم
      navigator.pushReplacement(
        PageRouteBuilder<void>(
          settings: const RouteSettings(name: AppRouter.welcome),
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const SplashScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final green = isDark ? AppColors.primaryOnDark : AppColors.primary;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 240,
                  child: AspectRatio(
                    aspectRatio: _MountainPainter.logoWidth /
                        _MountainPainter.logoHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // الخط اللي يترسم، ويختفي تدريجياً
                        Opacity(
                          opacity: 1 - _fill.value,
                          child: CustomPaint(
                            painter: _MountainPainter(progress: _draw.value),
                          ),
                        ),
                        // الشعار الحقيقي يظهر فوقه
                        Opacity(
                          opacity: _fill.value,
                          child: Image.asset(_logoImage, fit: BoxFit.contain),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Opacity(
                  opacity: _text.value,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - _text.value)),
                    // الشعار ثابت: Qimmah | قمّة مهما كانت لغة التطبيق
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Qimmah',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: green,
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 28,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            color: green,
                          ),
                          Text(
                            'قمّة',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// يرسم حدود الجبل (قمتين + الفروع) خطوة خطوة.
/// النقاط مأخوذة من صورة الشعار الأصلية (753 × 363) ثم تتكبّر/تصغر حسب المساحة.
class _MountainPainter extends CustomPainter {
  _MountainPainter({required this.progress});

  static const double logoWidth = 753;
  static const double logoHeight = 363;

  // لون الشعار الأصلي عشان ينتقل للصورة الحقيقية بدون ما يبان فرق
  static const Color _stroke = Color(0xFFB46038);

  // حدود الشعار الحقيقية (مع الفروع): تبدأ من طرف الجبل اليسار، تمشي على القمم،
  // ثم ترجع من تحت وتلف على الفروع لين تقفل الشكل
  static const List<Offset> _points = [
    Offset(11, 325),
    Offset(148, 186),
    Offset(158, 181),
    Offset(166, 181),
    Offset(181, 185),
    Offset(313, 57),
    Offset(320, 53),
    Offset(323, 54),
    Offset(329, 60),
    Offset(348, 86),
    Offset(351, 88),
    Offset(426, 12),
    Offset(432, 11),
    Offset(440, 18),
    Offset(565, 173),
    Offset(573, 171),
    Offset(588, 164),
    Offset(592, 164),
    Offset(600, 172),
    Offset(644, 226),
    Offset(723, 314),
    Offset(731, 325),
    Offset(739, 341),
    Offset(741, 351),
    Offset(739, 352),
    Offset(726, 345),
    Offset(685, 319),
    Offset(662, 302),
    Offset(627, 267),
    Offset(581, 214),
    Offset(577, 214),
    Offset(574, 217),
    Offset(572, 227),
    Offset(575, 239),
    Offset(582, 256),
    Offset(581, 264),
    Offset(578, 265),
    Offset(574, 263),
    Offset(559, 251),
    Offset(541, 231),
    Offset(527, 210),
    Offset(518, 189),
    Offset(517, 177),
    Offset(519, 171),
    Offset(493, 140),
    Offset(433, 63),
    Offset(406, 100),
    Offset(388, 121),
    Offset(388, 123),
    Offset(406, 145),
    Offset(433, 183),
    Offset(458, 206),
    Offset(481, 234),
    Offset(501, 266),
    Offset(514, 292),
    Offset(513, 295),
    Offset(507, 295),
    Offset(492, 287),
    Offset(424, 219),
    Offset(422, 219),
    Offset(419, 222),
    Offset(418, 225),
    Offset(418, 237),
    Offset(424, 255),
    Offset(424, 263),
    Offset(421, 267),
    Offset(417, 265),
    Offset(399, 246),
    Offset(387, 228),
    Offset(385, 221),
    Offset(385, 210),
    Offset(389, 198),
    Offset(389, 191),
    Offset(387, 187),
    Offset(348, 149),
    Offset(333, 129),
    Offset(319, 106),
    Offset(316, 104),
    Offset(300, 133),
    Offset(286, 154),
    Offset(257, 174),
    Offset(242, 188),
    Offset(241, 193),
    Offset(243, 197),
    Offset(258, 213),
    Offset(260, 217),
    Offset(252, 229),
    Offset(236, 247),
    Offset(203, 278),
    Offset(201, 278),
    Offset(199, 275),
    Offset(199, 262),
    Offset(202, 256),
    Offset(217, 237),
    Offset(217, 227),
    Offset(213, 224),
    Offset(207, 226),
    Offset(196, 233),
    Offset(186, 232),
    Offset(168, 215),
    Offset(162, 213),
    Offset(158, 215),
    Offset(155, 219),
    Offset(134, 259),
    Offset(126, 267),
    Offset(20, 327),
    Offset(13, 329),
    Offset(11, 328),
  ];

  final double progress; // من 0 إلى 1

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final scaleX = size.width / logoWidth;
    final scaleY = size.height / logoHeight;

    final path = Path()
      ..moveTo(_points.first.dx * scaleX, _points.first.dy * scaleY);
    for (final p in _points.skip(1)) {
      path.lineTo(p.dx * scaleX, p.dy * scaleY);
    }
    path.close(); // يرجع لنقطة البداية ويقفل الشكل

    final paint = Paint()
      ..color = _stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * scaleX
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // نرسم جزء من الخط بس حسب التقدّم
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(
        metric.extractPath(0, metric.length * progress.clamp(0.0, 1.0)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MountainPainter oldDelegate) =>
      oldDelegate.progress != progress;
}