from sqlalchemy.exc import IntegrityError

from app.errors import APIError
from app.extensions import db

REPORT_REASONS = ("spam", "offensive", "inappropriate", "other")


class ReviewReport(db.Model):
    """A user's report about a review."""
    __tablename__ = "review_reports"

    id = db.Column(db.Integer, primary_key=True)
    review_id = db.Column(db.Integer,
                          db.ForeignKey("reviews.id", ondelete="CASCADE"), nullable=False)
    reporter_id = db.Column(db.Integer,
                            db.ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    reason = db.Column(db.String(30), nullable=False)
    created_at = db.Column(db.DateTime, server_default=db.func.now())

    __table_args__ = (db.UniqueConstraint("review_id", "reporter_id",
                                          name="uq_report_review_reporter"),)

    @classmethod
    def add_report(cls, review_id, reporter_id, reason):
        from app.models.review import Review

        review = db.session.get(Review, review_id)
        if review is None:
            raise APIError("Review not found", 404)
        if review.user_id == reporter_id:
            raise APIError("You cannot report your own review", 400)

        reason = reason.strip().lower() if isinstance(reason, str) else ""
        if reason not in REPORT_REASONS:
            raise APIError("Invalid report reason", 400)

        if cls.query.filter_by(review_id=review_id, reporter_id=reporter_id).first():
            raise APIError("You already reported this review", 409)

        report = cls(review_id=review_id, reporter_id=reporter_id, reason=reason)
        db.session.add(report)
        try:
            db.session.commit()
        except IntegrityError:
            db.session.rollback()
            raise APIError("You already reported this review", 409)
        return report
