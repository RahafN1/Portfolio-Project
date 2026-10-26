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
from flask import Blueprint, jsonify, request

from app.utils.decorators import admin_required

admin_bp = Blueprint("admin", __name__)


def _body():
    """The JSON body, or {} if it is missing or not valid JSON."""
    data = request.get_json(silent=True)
    return data if isinstance(data, dict) else {}


@admin_bp.post("/trails")
@admin_required
def add_trail(current_user):
    trail = current_user.add_trail(_body())
    return jsonify({"trail": trail.to_dict()}), 201