"""Reviews module — Stage 3 endpoints 16-19.

16. GET    /api/trails/{id}/reviews   🌐  (done)
17. POST   /api/trails/{id}/reviews   🔒  (done)
18. PUT    /api/reviews/{id}          🔒  owner only (done)
19. DELETE /api/reviews/{id}          🔒  owner only (done)

The blueprint is registered with url_prefix="/api" in app/__init__.py.
"""
from flask import Blueprint, jsonify, request
from sqlalchemy import func

from app.errors import APIError
from app.extensions import db
from app.models.review import Review
from app.models.trail import Trail
from app.models.user import User
from app.utils.decorators import login_required

reviews_bp = Blueprint("reviews", __name__)


# ---------- Endpoint 16 ----------

@reviews_bp.get("/trails/<int:trail_id>/reviews")
def get_trail_reviews(trail_id):
    """Endpoint 16 — a trail's reviews with the average rating.
    ---
    tags:
      - Reviews
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
      - in: query
        name: page
        type: integer
        required: false
        default: 1
      - in: query
        name: limit
        type: integer
        required: false
        default: 10
    responses:
      200:
        description: The trail's reviews
      404:
        description: Trail not found
    """
    # 1) نتأكد إن المسار موجود
    if db.session.get(Trail, trail_id) is None:
        raise APIError("Trail not found", 404)

    # 2) نقرأ page و limit (اختياريين) ونضبط حدودهم
    page = request.args.get("page", default=1, type=int)
    limit = request.args.get("limit", default=10, type=int)
    if page < 1:
        page = 1
    if limit < 1:
        limit = 10
    if limit > 50:
        limit = 50

    # 3) المتوسط والعدد الكلي بنداء واحد للقاعدة
    avg_rating, total = (
        db.session.query(func.avg(Review.rating), func.count(Review.id))
        .filter(Review.trail_id == trail_id)
        .one()
    )
    average_rating = None
    if avg_rating is not None:
        average_rating = round(float(avg_rating), 1)

    # 4) نجيب التقييمات مع اسم صاحبها بـ join (بدون relationships)
    rows = (
        db.session.query(Review, User)
        .join(User, Review.user_id == User.id)
        .filter(Review.trail_id == trail_id)
        .order_by(Review.created_at.desc())
        .offset((page - 1) * limit)
        .limit(limit)
        .all()
    )

    # 5) نبني الرد
    reviews = []
    for review, user in rows:
        data = review.to_dict()
        data["user"] = {"id": user.id, "name": user.name}
        reviews.append(data)

    return jsonify({
        "average_rating": average_rating,
        "reviews": reviews,
        "page": page,
        "total": total,
    }), 200


# ---------- Endpoint 17 ----------

@reviews_bp.post("/trails/<int:trail_id>/reviews")
@login_required
def add_review(current_user, trail_id):
    """Endpoint 17 — add a review to a trail.
    ---
    tags:
      - Reviews
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
          properties:
            rating:
              type: integer
              example: 5
            comment:
              type: string
              example: مسار رائع وإطلالات جميلة
    responses:
      201:
        description: Review created
      400:
        description: Rating not 1-5 or empty comment
      401:
        description: Missing or expired token
      404:
        description: Trail not found
    """
    data = request.get_json(silent=True) or {}

    # add_review (في الـ model) يتأكد من المسار والتقييم والتعليق
    review = Review.add_review(
        current_user.id,
        trail_id,
        data.get("rating"),
        data.get("comment"),
    )
    return jsonify(review.to_dict()), 201


# ---------- Endpoint 18 ----------

@reviews_bp.put("/reviews/<int:review_id>")
@login_required
def update_review(current_user, review_id):
    """Endpoint 18 — edit your own review.
    ---
    tags:
      - Reviews
    security:
      - Bearer: []
    parameters:
      - in: path
        name: review_id
        type: integer
        required: true
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            rating:
              type: integer
              example: 4
            comment:
              type: string
              example: مسار جميل لكنه مزدحم في الإجازات
    responses:
      200:
        description: The updated review
      400:
        description: Invalid input
      401:
        description: Missing or expired token
      403:
        description: Not the review's owner
      404:
        description: Review not found
    """
    data = request.get_json(silent=True) or {}

    # لازم يرسل شي واحد على الأقل يتعدل
    if "rating" not in data and "comment" not in data:
        raise APIError("Send rating or comment to update", 400)

    # update_review (في الـ model) يتأكد إنه صاحب التقييم
    review = Review.update_review(
        review_id,
        current_user.id,
        rating=data.get("rating"),
        comment=data.get("comment"),
    )
    return jsonify(review.to_dict()), 200


# ---------- Endpoint 19 ----------

@reviews_bp.delete("/reviews/<int:review_id>")
@login_required
def delete_review(current_user, review_id):
    """Endpoint 19 — delete your own review.
    ---
    tags:
      - Reviews
    security:
      - Bearer: []
    parameters:
      - in: path
        name: review_id
        type: integer
        required: true
    responses:
      204:
        description: Review deleted
      401:
        description: Missing or expired token
      403:
        description: Not the review's owner
      404:
        description: Review not found
    """
    # delete_review (في الـ model) يتأكد إنه صاحب التقييم
    Review.delete_review(review_id, current_user.id)
    return "", 204
