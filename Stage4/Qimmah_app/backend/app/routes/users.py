"""Users module — Stage 3 endpoints 5-13 (to be built).

5.  GET    /api/users/me                               🔒
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
from flask import Blueprint

users_bp = Blueprint("users", __name__)
