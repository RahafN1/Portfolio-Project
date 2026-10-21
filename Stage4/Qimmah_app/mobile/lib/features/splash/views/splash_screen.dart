import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_viewmodel.dart';

/// صفحة البداية (Splash): صورة متحركة ببطء + الشعار + زر ابدأ الاستكشاف
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String heroImage = 'assets/images/splash_hero.jpg';
  static const String logoImage = 'assets/images/logo_mountains.png';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _pan;

  @override
  void initState() {
    super.initState();

    // الكاميرا تمشي على الصورة العريضة: تبدأ عند الرجل (يمين)
    // وتتحرك لين توصل كتابة "اكتشف مسارات السعودية" (يسار)، وترجع
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );

    _pan = TweenSequence<Alignment>([
      // وقفة عند الرجل
      TweenSequenceItem(
        tween: ConstantTween(Alignment.centerRight),
        weight: 20,
      ),
      // الحركة من اليمين لليسار
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 60,
      ),
      // وقفة عند الكتابة
      TweenSequenceItem(
        tween: ConstantTween(Alignment.centerLeft),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // تحميل الصورة مسبقاً عشان ما تومض أول ما تفتح الصفحة
    precacheImage(const AssetImage(SplashScreen.heroImage), context);

    // احترام إعداد "تقليل الحركة" في جهاز المستخدم
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        // على الويب (Vercel) نخلي الصفحة بعرض جوال بدل ما تتمدد على الشاشة كلها
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Expanded(child: _buildHero(bg, isDark)),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  child: _buildContent(isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- الصورة المتحركة ----------------

  Widget _buildHero(Color bg, bool isDark) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: AnimatedBuilder(
            animation: _pan,
            // نحرّك الجزء الظاهر من الصورة العريضة
            builder: (context, _) => Image.asset(
              SplashScreen.heroImage,
              fit: BoxFit.cover,
              alignment: _pan.value,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),

        // تلاشي أسفل الصورة مع لون الخلفية
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 160,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bg.withValues(alpha: 0), bg],
                ),
              ),
            ),
          ),
        ),

        // أزرار اللغة والثيم أعلى اليسار
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    _glassButton(
                      isDark: isDark,
                      tooltip: 'English',
                      // TODO: الإنجليزي Could Have — نربطه لاحقاً
                      onTap: null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'EN',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.language,
                            size: 18,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _glassButton(
                      isDark: isDark,
                      tooltip: isDark ? 'الوضع الفاتح' : 'الوضع الداكن',
                      onTap: () {
                         final isDark = Theme.of(context).brightness == Brightness.dark;
                        context.read<ThemeViewModel>().setDark(!isDark);
                      },
                      padding: const EdgeInsets.all(9),
                      child: Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        size: 18,
                        color:
                            isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _glassButton({
    required bool isDark,
    required String tooltip,
    required VoidCallback? onTap,
    required EdgeInsets padding,
    required Widget child,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isDark
            ? Colors.black.withValues(alpha: 0.45)
            : Colors.white.withValues(alpha: 0.85),
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }

  // ---------------- الشعار والأزرار ----------------

  Widget _buildContent(bool isDark) {
    final green = isDark ? AppColors.primaryOnDark : AppColors.primary;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(SplashScreen.logoImage, height: 36),
        const SizedBox(height: 8),

        // الشعار ثابت: Qimmah | قمّة مهما كانت لغة التطبيق
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppStrings.appNameEn,
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
                AppStrings.appNameAr,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        const Text(
          AppStrings.tagline,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 32),

        // زر ابدأ الاستكشاف (يدخل كضيف)
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(AppRouter.explore),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  AppStrings.startExploring,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                // في العربي (RTL) السهم يطلع يسار ويأشّر لليسار تلقائياً
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(Icons.arrow_forward, size: 20),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${AppStrings.haveAccount} ',
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRouter.login),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  AppStrings.loginLink,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: green,
                    decoration: TextDecoration.underline,
                    decorationColor: green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}