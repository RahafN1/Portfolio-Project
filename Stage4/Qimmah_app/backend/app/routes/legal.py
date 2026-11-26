"""Public privacy policy page (linked from the app and App Store Connect)."""
from flask import Blueprint

legal_bp = Blueprint("legal", __name__)

PAGE = """<!doctype html>
<html lang="ar">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Qimmah - Privacy Policy</title>
<style>body{font-family:sans-serif;max-width:700px;margin:auto;padding:16px;line-height:1.7}</style>
</head>
<body>
<section lang="ar" dir="rtl">
<h1>سياسة الخصوصية لتطبيق قمّة</h1>
<p>آخر تحديث: 26 نوفمبر 2026</p>
<h2>البيانات التي نجمعها</h2>
<p>الاسم والبريد الإلكتروني وكلمة المرور (تُحفظ مشفّرة بالتجزئة)، والتقييمات والبلاغات، والمسارات المفضلة والمكتملة.</p>
<h2>الموقع</h2>
<p>يُستخدم موقعك أثناء استخدام التطبيق لعرض مكانك على الخريطة ومعرفة هل أنت على المسار. لا نرسل موقعك إلى خوادمنا ولا نخزنه. يمكنك إيقاف الإذن من إعدادات الجهاز.</p>
<h2>استخدام البيانات</h2>
<p>لتشغيل حسابك، وإرسال رمز التحقق، وعرض تقييماتك باسمك للآخرين، ومراجعة البلاغات. لا نبيع بياناتك ولا نستخدمها للإعلانات أو التتبع.</p>
<h2>خدمات خارجية</h2>
<p>Railway (استضافة الخادم)، Aiven (قاعدة البيانات)، Resend (إرسال البريد)، Cloudinary (صور المسارات)، OpenStreetMap (صور الخريطة، ويصلها عنوان IP والمنطقة المعروضة، وقد تكون قريبة من موقعك).</p>
<h2>الاحتفاظ والحذف</h2>
<p>نحتفظ ببياناتك ما دام حسابك قائماً. يمكنك حذف الحساب من داخل التطبيق (الملف الشخصي ثم حذف الحساب)، فتُحذف بياناتك وتقييماتك ومساراتك المحفوظة. ولسحب موافقتك أو طلب الحذف راسلنا.</p>
<h2>المحتوى المسيء</h2>
<p>لا نسمح بالمحتوى المسيء. يمكنك الإبلاغ عن أي تقييم، ونراجع البلاغات وقد نحذف المحتوى أو نوقف الحساب.</p>
<h2>تواصل معنا</h2>
<p><a href="mailto:qimmah.info@gmail.com">qimmah.info@gmail.com</a></p>
</section>
<hr>
<section lang="en" dir="ltr">
<h1>Qimmah Privacy Policy</h1>
<p>Last updated: 26 November 2026</p>
<h2>Data we collect</h2>
<p>Your name, email address and password (stored only as a hash), your reviews and reports, and your favorite and completed trails.</p>
<h2>Location</h2>
<p>Your location is used while you use the app to show where you are on the map and whether you are on the trail. We do not send it to our servers or store it. You can turn the permission off in your device settings.</p>
<h2>How we use data</h2>
<p>To run your account, send verification codes, show your reviews with your name to others, and review reports. We do not sell your data or use it for advertising or tracking.</p>
<h2>Third-party services</h2>
<p>Railway (server hosting), Aiven (database), Resend (email delivery), Cloudinary (trail images), OpenStreetMap (map tiles; it receives your IP address and the map area shown, which may be near your location).</p>
<h2>Retention and deletion</h2>
<p>We keep your data while your account exists. You can delete your account in the app (Profile, then Delete account), which removes your data, reviews and saved trails. To withdraw consent or request deletion, email us.</p>
<h2>Objectionable content</h2>
<p>Abusive content is not allowed. You can report any review; we review reports and may remove content or suspend accounts.</p>
<h2>Contact us</h2>
<p><a href="mailto:qimmah.info@gmail.com">qimmah.info@gmail.com</a></p>
</section>
</body>
</html>
"""  # noqa: E501


@legal_bp.get("/privacy")
def privacy():
    return PAGE
