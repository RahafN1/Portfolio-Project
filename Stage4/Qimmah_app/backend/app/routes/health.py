"""وحدة فحص الصحة (Health Check) للتأكد من أن الـ API يعمل."""

from flask import Blueprint, jsonify

health_bp = Blueprint("health", __name__)


@health_bp.get("/health")
def health():
    """Check that the API is running.

    Endpoint خفيف يُستخدم في المراقبة (monitoring) وأدوات الـ
    load balancer وفحوصات الـ container للتأكد من أن التطبيق
    يعمل ويستجيب للطلبات.

    Returns:
        tuple: استجابة JSON بصيغة ``{"status": "ok"}`` مع
        رمز الحالة 200.

    Example:
        GET /health

        Response (200 OK)::

            {"status": "ok"}
    """
    return jsonify({"status": "ok"})
