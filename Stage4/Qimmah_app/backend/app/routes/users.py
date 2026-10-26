"""Users module — Stage 3 endpoints 5-13 (to be built).

5.  GET    /api/users/me                               🔒  (done)
6.  PUT    /api/users/me                               🔒
7.  GET    /api/users/me/reviews                       🔒
8.  GET    /api/users/me/favorites                     🔒
9.  POST   /api/users/me/favorites                     🔒
10. DELETE /api/users/me/favorites/{trail_id}          🔒
11. GET    /api/users/me/completed-trails              🔒
12. POST   /api/users/me/completed-trails              🔒
13. DELETE /api/users/me/completed-trails/{trail_id}   🔒

Protect each route with @login_required from app.utils.decorators.
"""
from flask import Blueprint, jsonify

from app.utils.decorators import login_required

users_bp = Blueprint("users", __name__)


@users_bp.get("/me")
@login_required
def get_current_user(current_user):
    return jsonify({"user": current_user.to_dict()}), 200