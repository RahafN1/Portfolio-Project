from app.errors import APIError
from app.extensions import db


class CompletedTrail(db.Model):
    """A trail the user marked as completed (UML: CompletedTrail)."""
    __tablename__ = "completed_trails"

    # ---------- Attributes ----------
    user_id = db.Column("userId", db.Integer,
                        db.ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    trail_id = db.Column("trailId", db.Integer,
                         db.ForeignKey("trails.id", ondelete="CASCADE"), primary_key=True)
    completed_at = db.Column("completedAt", db.DateTime, server_default=db.func.now())

    # ---------- Helpers ----------
    def to_dict(self):
        """Trail summary + completion date (endpoint 11)."""
        data = self.trail.get_summary()
        data["completed_at"] = self.completed_at.isoformat() + "Z" if self.completed_at else None
        return data

    # ---------- Methods (UML) ----------
    @classmethod
    def mark_as_completed(cls, user_id, trail_id):
        """UML: markAsCompleted(userId, trailId) (endpoint 12)."""
        from app.models import Trail

        if db.session.get(Trail, trail_id) is None:
            raise APIError("Trail not found", 404)
        if cls.is_completed(user_id, trail_id):
            raise APIError("Trail already marked as completed", 409)
        completed = cls(user_id=user_id, trail_id=trail_id)
        db.session.add(completed)
        db.session.commit()
        return completed

    @classmethod
    def remove_completed_trail(cls, user_id, trail_id):
        """UML: removeCompletedTrail(userId, trailId) (endpoint 13)."""
        completed = db.session.get(cls, (user_id, trail_id))
        if completed is None:
            raise APIError("Trail not in completed list", 404)
        db.session.delete(completed)
        db.session.commit()

    @classmethod
    def get_completed_trails(cls, user_id):
        """UML: getCompletedTrails(userId) — newest first."""
        return (cls.query.filter_by(user_id=user_id)
                .order_by(cls.completed_at.desc()).all())

    @classmethod
    def is_completed(cls, user_id, trail_id):
        """UML: isCompleted(userId, trailId)."""
        return db.session.get(cls, (user_id, trail_id)) is not None
