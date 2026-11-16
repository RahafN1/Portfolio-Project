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
from app.services.cloudinary_service import upload_image
from flask import Blueprint, jsonify, request

from app.errors import APIError

from app.utils.decorators import admin_required

admin_bp = Blueprint("admin", __name__)


def _body():
    """The JSON body, or {} if it is missing or not valid JSON."""
    data = request.get_json(silent=True)
    return data if isinstance(data, dict) else {}

#20
@admin_bp.post("/trails")
@admin_required
def add_trail(current_user):
    trail = current_user.add_trail(_body())
    return jsonify({"trail": trail.get_details()}), 201

# 21
@admin_bp.put("/trails/<int:trail_id>")
@admin_required
def update_trail(current_user, trail_id):
    trail = current_user.update_trail(trail_id, _body())
    return jsonify({"trail": trail.get_details()}), 200


# 22
@admin_bp.delete("/trails/<int:trail_id>")
@admin_required
def delete_trail(current_user, trail_id):
    current_user.delete_trail(trail_id)
    return jsonify({"message": "Trail deleted"}), 200



# 23
@admin_bp.post("/trails/<int:trail_id>/images")
@admin_required
def upload_trail_images(current_user, trail_id):
    files = request.files.getlist("images")
    if not files:
        raise APIError("images must be sent as files", 400)
    urls = [upload_image(f) for f in files]
    image_list = current_user.upload_trail_images(trail_id, urls)
    return jsonify({"images": image_list}), 200


# 24
@admin_bp.put("/trails/<int:trail_id>/route")
@admin_required
def update_trail_route(current_user, trail_id):
    route = _body().get("route_coordinates")
    trail = current_user.update_trail_route(trail_id, route)
    return jsonify({"trail": trail.get_details()}), 200


# 25
@admin_bp.delete("/reviews/<int:review_id>")
@admin_required
def delete_review(current_user, review_id):
    current_user.delete_review(review_id)
    return jsonify({"message": "Review deleted"}), 200


# 26
@admin_bp.patch("/users/<int:user_id>/suspend")
@admin_required
def suspend_user(current_user, user_id):
    user = current_user.suspend_user(user_id)
    return jsonify({"message": "User suspended",
                    "user": {**user.to_dict(), "isSuspended": user.is_suspended}}), 200
def _page_args():
    """page and limit from the query string (limit between 1 and 100)."""
    page = request.args.get("page", default=1, type=int)
    limit = request.args.get("limit", default=20, type=int)
    if page < 1:
        page = 1
    if limit < 1:
        limit = 20
    if limit > 100:
        limit = 100
    return page, limit


# 27
@admin_bp.get("/stats")
@admin_required
def get_stats(current_user):
    return jsonify(current_user.get_stats()), 200


# 28
@admin_bp.get("/users")
@admin_required
def list_users(current_user):
    page, limit = _page_args()
    users, total = current_user.list_users(page, limit)
    return jsonify({"users": users, "page": page, "total": total}), 200


# 29
@admin_bp.get("/reviews")
@admin_required
def list_reviews(current_user):
    page, limit = _page_args()
    reviews, total = current_user.list_reviews(page, limit)
    return jsonify({"reviews": reviews, "page": page, "total": total}), 200


# 30
@admin_bp.patch("/users/<int:user_id>/unsuspend")
@admin_required
def unsuspend_user(current_user, user_id):
    user = current_user.unsuspend_user(user_id)
    return jsonify({
        "message": "User unsuspended",
        "user": {**user.to_dict(), "isSuspended": user.is_suspended},
    }), 200
