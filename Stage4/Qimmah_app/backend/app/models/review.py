from app.errors import APIError
from app.extensions import db


class Review(db.Model):
    """A rating (1-5) with a comment (UML: Review)."""
    __tablename__ = "reviews"

    # ---------- Attributes ----------
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column("userId", db.Integer,
                        db.ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    trail_id = db.Column("trailId", db.Integer,
                         db.ForeignKey("trails.id", ondelete="CASCADE"), nullable=False)
    rating = db.Column(db.Integer, nullable=False)
    comment = db.Column(db.Text, nullable=False)
    created_at = db.Column("createdAt", db.DateTime, server_default=db.func.now())

    __table_args__ = (
        db.CheckConstraint("rating BETWEEN 1 AND 5", name="ck_reviews_rating"),
    )

    # ---------- Helpers ----------
    def to_dict(self, with_user=False, with_trail=False):
        data = {
            "id": self.id,
            "trail_id": self.trail_id,
            "rating": self.rating,
            "comment": self.comment,
            "created_at": self.created_at.isoformat() + "Z" if self.created_at else None,
        }
        if with_user:
            data["user"] = {"id": self.user.id, "name": self.user.name}
        if with_trail:
            data["trail"] = {"id": self.trail.id, "name": self.trail.name}
        return data

    @staticmethod
    def _validate_comment(comment):
        comment = (comment or "").strip()
        if not comment:
            raise APIError("Comment cannot be empty", 400)
        return comment

    # ---------- Methods (UML) ----------
    @staticmethod
    def validate_rating(rating):
        """UML: validateRating(rating) — must be a whole number from 1 to 5."""
        if isinstance(rating, bool) or not isinstance(rating, int) or not 1 <= rating <= 5:
            raise APIError("Rating must be a whole number from 1 to 5", 400)
        return rating

    @classmethod
    def add_review(cls, user_id, trail_id, rating, comment):
        """UML: addReview(userId, trailId, rating, comment) (endpoint 17)."""
        from app.models import Trail

        if db.session.get(Trail, trail_id) is None:
            raise APIError("Trail not found", 404)
        review = cls(user_id=user_id, trail_id=trail_id,
                     rating=cls.validate_rating(rating),
                     comment=cls._validate_comment(comment))
        db.session.add(review)
        db.session.commit()
        return review

    @classmethod
    def get_review(cls, review_id):
        """UML: getReview(reviewId)."""
        review = db.session.get(cls, review_id)
        if review is None:
            raise APIError("Review not found", 404)
        return review

    @classmethod
    def update_review(cls, review_id, user_id, rating=None, comment=None):
        """UML: updateReview(reviewId, rating, comment) (endpoint 18).
        user_id is added so only the review's owner can edit it."""
        review = cls.get_review(review_id)
        if review.user_id != user_id:
            raise APIError("You can only edit your own reviews", 403)
        if rating is not None:
            review.rating = cls.validate_rating(rating)
        if comment is not None:
            review.comment = cls._validate_comment(comment)
        db.session.commit()
        return review

    @classmethod
    def delete_review(cls, review_id, user_id):
        """UML: deleteReview(reviewId) (endpoint 19).
        user_id is added so only the review's owner can delete it."""
        review = cls.get_review(review_id)
        if review.user_id != user_id:
            raise APIError("You can only delete your own reviews", 403)
        db.session.delete(review)
        db.session.commit()
