from sqlalchemy import func

from app.errors import APIError
from app.extensions import db
from app.models import Review, Trail


class ReviewService:
    """Reviews logic (UML: ReviewService)."""

    @staticmethod
    def get_reviews(trail_id, page=1, limit=20):
        """UML: getReviews(trailId) — newest first (endpoint 16).
        Returns (reviews, total)."""
        if db.session.get(Trail, trail_id) is None:
            raise APIError("Trail not found", 404)
        if page < 1 or not 1 <= limit <= 100:
            raise APIError("page must be >= 1 and limit between 1 and 100", 400)
        query = Review.query.filter_by(trail_id=trail_id)
        total = query.count()
        reviews = (query.order_by(Review.created_at.desc())
                   .offset((page - 1) * limit).limit(limit).all())
        return reviews, total

    @staticmethod
    def calculate_average_rating(trail_id):
        """UML: calculateAverageRating(trailId) — 1 decimal, or None if no reviews."""
        average = (db.session.query(func.avg(Review.rating))
                   .filter(Review.trail_id == trail_id).scalar())
        return round(float(average), 1) if average is not None else None

    @staticmethod
    def delete_inappropriate_review(review_id):
        """UML: deleteInappropriateReview(reviewId) — admins only (endpoint 25)."""
        review = db.session.get(Review, review_id)
        if review is None:
            raise APIError("Review not found", 404)
        db.session.delete(review)
        db.session.commit()