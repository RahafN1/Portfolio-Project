"""Users module — Stage 3 endpoints 5-13.

5.  GET    /api/users/me                               🔒  (done)
6.  PUT    /api/users/me                               🔒
7.  GET    /api/users/me/reviews                       🔒  (done)
8.  GET    /api/users/me/favorites                     🔒  (done)
9.  POST   /api/users/me/favorites                     🔒  (done)
10. DELETE /api/users/me/favorites/{trail_id}          🔒  (done)
11. GET    /api/users/me/completed-trails              🔒
12. POST   /api/users/me/completed-trails              🔒
13. DELETE /api/users/me/completed-trails/{trail_id}   🔒

Protect each route with @login_required from app.utils.decorators.
"""
from flask import Blueprint, jsonify, request

from app.errors import APIError
from app.extensions import db
from app.models.completed_trail import CompletedTrail
from app.models.favorite import Favorite
from app.models.review import Review
from app.models.trail import Trail
from app.utils.decorators import login_required

users_bp = Blueprint("users", __name__)


@users_bp.get("/me")
@login_required
def get_current_user(current_user):
    return jsonify({"user": current_user.to_dict()}), 200


# ---------- Reviews (endpoint 7) ----------

@users_bp.get("/me/reviews")
@login_required
def list_my_reviews(current_user):
    """Endpoint 7 — my reviews, newest first.
    ---
    tags:
      - Reviews
    security:
      - Bearer: []
    responses:
      200:
        description: The user's reviews, each with its trail
      401:
        description: Missing or expired token
    """
    rows = (db.session.query(Review, Trail)
            .join(Trail, Review.trail_id == Trail.id)
            .filter(Review.user_id == current_user.id)
            .order_by(Review.created_at.desc(), Review.id.desc())
            .all())

    reviews = []
    for review, trail in rows:
        data = review.to_dict()
        data["trail"] = {"id": trail.id, "name": trail.name}
        reviews.append(data)

    return jsonify({"reviews": reviews, "total": len(reviews)}), 200


# ---------- Favorites (endpoints 8-10) ----------

@users_bp.get("/me/favorites")
@login_required
def list_favorites(current_user):
    """Endpoint 8 — list saved trails, newest first.
    ---
    tags:
      - Favorites
    security:
      - Bearer: []
    responses:
      200:
        description: The user's saved trails
      401:
        description: Missing or expired token
    """
    trails = (Trail.query
              .join(Favorite, Favorite.trail_id == Trail.id)
              .filter(Favorite.user_id == current_user.id)
              .order_by(Favorite.created_at.desc())
              .all())
    return jsonify({"trails": [t.get_summary() for t in trails],
                    "total": len(trails)}), 200


@users_bp.post("/me/favorites")
@login_required
def add_favorite(current_user):
    """Endpoint 9 — save a trail.
    ---
    tags:
      - Favorites
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            trail_id:
              type: integer
              example: 1
    responses:
      201:
        description: Trail added to favorites
      400:
        description: trail_id missing or not an integer
      401:
        description: Missing or expired token
      404:
        description: Trail not found
      409:
        description: Already in favorites
    """
    data = request.get_json(silent=True) or {}
    trail_id = data.get("trail_id")
    if not isinstance(trail_id, int) or isinstance(trail_id, bool):
        raise APIError("trail_id is required and must be an integer", 400)

    favorite = current_user.add_favorite(trail_id)
    return jsonify({
        "message": "Trail added to favorites",
        "trail_id": favorite.trail_id,
        "created_at": favorite.created_at.isoformat() + "Z",
    }), 201


@users_bp.delete("/me/favorites/<int:trail_id>")
@login_required
def remove_favorite(current_user, trail_id):
    """Endpoint 10 — remove a saved trail.
    ---
    tags:
      - Favorites
    security:
      - Bearer: []
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
        description: The trail's ID
    responses:
      204:
        description: Removed from favorites
      401:
        description: Missing or expired token
      404:
        description: Trail not in favorites
    """
    current_user.remove_favorite(trail_id)
    return "", 204


# ---------- Completed trails (endpoints 11-13) ----------

@users_bp.get("/me/completed-trails")
@login_required
def list_completed_trails(current_user):
    """Endpoint 11 — completed trails, newest first.
    ---
    tags:
      - Completed Trails
    security:
      - Bearer: []
    responses:
      200:
        description: The user's completed trails
      401:
        description: Missing or expired token
    """
    rows = (db.session.query(Trail, CompletedTrail)
            .join(CompletedTrail, CompletedTrail.trail_id == Trail.id)
            .filter(CompletedTrail.user_id == current_user.id)
            .order_by(CompletedTrail.completed_at.desc())
            .all())

    trails = []
    for trail, completed in rows:
        data = trail.get_summary()
        data["completed_at"] = completed.completed_at.isoformat() + "Z"
        trails.append(data)

    return jsonify({"trails": trails, "total": len(trails)}), 200


@users_bp.post("/me/completed-trails")
@login_required
def mark_trail_completed(current_user):
    """Endpoint 12 — mark a trail as completed.
    ---
    tags:
      - Completed Trails
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            trail_id:
              type: integer
              example: 1
    responses:
      201:
        description: Trail marked as completed
      400:
        description: trail_id missing or not an integer
      401:
        description: Missing or expired token
      404:
        description: Trail not found
      409:
        description: Already marked as completed
    """
    data = request.get_json(silent=True) or {}
    trail_id = data.get("trail_id")
    if not isinstance(trail_id, int) or isinstance(trail_id, bool):
        raise APIError("trail_id is required and must be an integer", 400)

    completed = CompletedTrail.mark_as_completed(current_user.id, trail_id)
    return jsonify({
        "message": "Trail marked as completed",
        "trail_id": completed.trail_id,
        "completed_at": completed.completed_at.isoformat() + "Z",
    }), 201


@users_bp.delete("/me/completed-trails/<int:trail_id>")
@login_required
def remove_completed_trail(current_user, trail_id):
    """Endpoint 13 — remove a trail from the completed list.
    ---
    tags:
      - Completed Trails
    security:
      - Bearer: []
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
        description: The trail's ID
    responses:
      204:
        description: Removed from completed trails
      401:
        description: Missing or expired token
      404:
        description: Trail not in completed list
    """
    CompletedTrail.remove_completed_trail(current_user.id, trail_id)
    return "", 204
