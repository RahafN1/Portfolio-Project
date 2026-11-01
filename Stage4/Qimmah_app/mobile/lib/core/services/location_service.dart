import 'package:geolocator/geolocator.dart';

// كل شي يخص موقع المستخدم
// الموقع يبقى على الجهاز، وما نرسله لأي سيرفر
class LocationService {
  // يرجّع موقع المستخدم الحالي، أو null لو ما قدرنا
  Future<Position?> getCurrentLocation() async {
    // 1) هل خدمة الموقع (GPS) شغّالة في الجهاز؟
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    // 2) هل عندنا إذن؟ لو لا، نطلبه (هنا تطلع نافذة النظام)
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 3) لو رفض، أو رفض نهائياً، نوقف
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    // 4) نجيب الموقع، ولو صار أي خطأ نرجّع null بدل ما يطيح التطبيق
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }
}