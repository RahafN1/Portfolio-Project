from datetime import datetime, timezone

from app.errors import APIError
from app.extensions import db


def _now():
    """Current UTC time without timezone info (MySQL DATETIME has none)."""
    return datetime.now(timezone.utc).replace(tzinfo=None)


class Favorite(db.Model):
    """A trail saved by a user (UML: Favorite)."""
    __tablename__ = "favorites"

    # ---------- Attributes ----------
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id", ondelete="CASCADE"),
                        nullable=False)
    trail_id = db.Column(db.Integer, db.ForeignKey("trails.id", ondelete="CASCADE"),
                         nullable=False)
    created_at = db.Column(db.DateTime, nullable=False, default=_now)

    # A user can save the same trail only once
    __table_args__ = (db.UniqueConstraint("user_id", "trail_id",
                                          name="uq_favorite_user_trail"),)

    # ---------- Helpers ----------
    def to_dict(self):
        return {"id": self.id, "trailId": self.trail_id,
                "createdAt": self.created_at.isoformat()}

    # ---------- Methods (UML) ----------
    @classmethod
    def get_user_favorites(cls, user_id):
        """All favorites of a user, newest first."""
        return (cls.query.filter_by(user_id=user_id)
                .order_by(cls.created_at.desc()).all())

    @classmethod
    def add_favorite(cls, user_id, trail_id):
        """Save a trail. 404 if the trail does not exist, 409 if already saved."""
        from app.models.trail import Trail
        if db.session.get(Trail, trail_id) is None:
            raise APIError("Trail not found", 404)
        if cls.query.filter_by(user_id=user_id, trail_id=trail_id).first():
            raise APIError("Trail already in favorites", 409)

        favorite = cls(user_id=user_id, trail_id=trail_id)
        db.session.add(favorite)
        db.session.commit()
        return favorite

    @classmethod
    def remove_favorite(cls, user_id, trail_id):
        """Remove a saved trail. 404 if it was not saved."""
        favorite = cls.query.filter_by(user_id=user_id, trail_id=trail_id).first()
        if favorite is None:
            raise APIError("Trail not in favorites", 404)
        db.session.delete(favorite)
        db.session.commit()