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
    """
    Endpoint 20 — add a new trail (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        description: The trail data
        schema:
          type: object
    responses:
      201:
        description: Trail created, returns the trail details
      400:
        description: Missing or invalid data
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
    """
    trail = current_user.add_trail(_body())
    return jsonify({"trail": trail.get_details()}), 201

# 21
@admin_bp.put("/trails/<int:trail_id>")
@admin_required
def update_trail(current_user, trail_id):
    """
    Endpoint 21 — edit a trail (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
      - in: body
        name: body
        required: true
        description: The trail fields to change
        schema:
          type: object
    responses:
      200:
        description: Trail updated, returns the trail details
      400:
        description: Missing or invalid data
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: Trail not found
    """
    trail = current_user.update_trail(trail_id, _body())
    return jsonify({"trail": trail.get_details()}), 200


# 22
@admin_bp.delete("/trails/<int:trail_id>")
@admin_required
def delete_trail(current_user, trail_id):
    """
    Endpoint 22 — delete a trail (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
    responses:
      200:
        description: Trail deleted
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: Trail not found
    """
    current_user.delete_trail(trail_id)
    return jsonify({"message": "Trail deleted"}), 200



# 23
@admin_bp.post("/trails/<int:trail_id>/images")
@admin_required
def upload_trail_images(current_user, trail_id):
    """
    Endpoint 23 — upload images for a trail (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    consumes:
      - multipart/form-data
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
      - in: formData
        name: images
        type: array
        items:
          type: file
        collectionFormat: multi
        required: true
        description: One or more image files
    responses:
      200:
        description: Images uploaded, returns the trail's image list
      400:
        description: Images must be sent as files
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: Trail not found
    """
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
    """
    Endpoint 24 — replace the route of a trail (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - route_coordinates
          properties:
            route_coordinates:
              type: array
              description: The route coordinates of the trail
              items:
                type: array
                items:
                  type: number
    responses:
      200:
        description: Route updated, returns the trail details
      400:
        description: Missing or invalid route
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: Trail not found
    """
    route = _body().get("route_coordinates")
    trail = current_user.update_trail_route(trail_id, route)
    return jsonify({"trail": trail.get_details()}), 200


# 25
@admin_bp.delete("/reviews/<int:review_id>")
@admin_required
def delete_review(current_user, review_id):
    """
    Endpoint 25 — delete any review (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: path
        name: review_id
        type: integer
        required: true
    responses:
      200:
        description: Review deleted
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: Review not found
    """
    current_user.delete_review(review_id)
    return jsonify({"message": "Review deleted"}), 200


# 26
@admin_bp.patch("/users/<int:user_id>/suspend")
@admin_required
def suspend_user(current_user, user_id):
    """
    Endpoint 26 — suspend a user (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: path
        name: user_id
        type: integer
        required: true
    responses:
      200:
        description: User suspended
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: User not found
    """
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
    """
    Endpoint 27 — dashboard statistics (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    responses:
      200:
        description: Statistics returned
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
    """
    return jsonify(current_user.get_stats()), 200


# 28
@admin_bp.get("/users")
@admin_required
def list_users(current_user):
    """
    Endpoint 28 — list all users, page by page (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: query
        name: page
        type: integer
        default: 1
        description: Page number
      - in: query
        name: limit
        type: integer
        default: 20
        description: Items per page (1 to 100)
    responses:
      200:
        description: Users returned with the page number and the total
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
    """
    page, limit = _page_args()
    users, total = current_user.list_users(page, limit)
    return jsonify({"users": users, "page": page, "total": total}), 200


# 29
@admin_bp.get("/reviews")
@admin_required
def list_reviews(current_user):
    """
    Endpoint 29 — list all reviews, page by page (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: query
        name: page
        type: integer
        default: 1
        description: Page number
      - in: query
        name: limit
        type: integer
        default: 20
        description: Items per page (1 to 100)
    responses:
      200:
        description: Reviews returned with the page number and the total
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
    """
    page, limit = _page_args()
    reviews, total = current_user.list_reviews(page, limit)
    return jsonify({"reviews": reviews, "page": page, "total": total}), 200


# 30
@admin_bp.patch("/users/<int:user_id>/unsuspend")
@admin_required
def unsuspend_user(current_user, user_id):
    """
    Endpoint 30 — unsuspend a user (admin only)
    ---
    tags:
      - Admin
    security:
      - Bearer: []
    parameters:
      - in: path
        name: user_id
        type: integer
        required: true
    responses:
      200:
        description: User unsuspended
      401:
        description: Missing, invalid or revoked token
      403:
        description: Admin only
      404:
        description: User not found
    """
    user = current_user.unsuspend_user(user_id)
    return jsonify({
        "message": "User unsuspended",
        "user": {**user.to_dict(), "isSuspended": user.is_suspended},
    }), 200
