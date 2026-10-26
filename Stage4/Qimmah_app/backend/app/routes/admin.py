"""Admin module — Stage 3 endpoints 20-26 (to be built).

20. POST   /api/admin/trails                🛠️
21. PUT    /api/admin/trails/{id}           🛠️
22. DELETE /api/admin/trails/{id}           🛠️
23. POST   /api/admin/trails/{id}/images    🛠️
24. PUT    /api/admin/trails/{id}/route     🛠️
25. DELETE /api/admin/reviews/{id}          🛠️
26. PATCH  /api/admin/users/{id}/suspend    🛠️

Protect each route with @admin_required from app.utils.decorators.
"""
from flask import Blueprint

admin_bp = Blueprint("admin", __name__)
