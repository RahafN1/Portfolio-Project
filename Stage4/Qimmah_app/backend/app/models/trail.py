import json

from app.extensions import db


class Trail(db.Model):
    """Trails table (Stage 3 design). Text fields are in Arabic."""
    __tablename__ = "trails"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False, index=True)
    description = db.Column(db.Text)
    region = db.Column(db.String(50), nullable=False, index=True)  # code: riyadh, hail, makkah...
    difficulty = db.Column(db.Enum("easy", "moderate", "hard"), nullable=False,
                           index=True)
    distance = db.Column(db.Numeric(5, 2), nullable=False)  # km
    estimated_duration = db.Column("estimatedDuration", db.String(50), nullable=False)
    images = db.Column(db.Text)  # JSON array of image URLs
    start_latitude = db.Column("startLatitude", db.Numeric(9, 6))
    start_longitude = db.Column("startLongitude", db.Numeric(9, 6))
    end_latitude = db.Column("endLatitude", db.Numeric(9, 6))
    end_longitude = db.Column("endLongitude", db.Numeric(9, 6))
    route_coordinates = db.Column("routeCoordinates", db.JSON)  # GeoJSON
    safety_tips = db.Column("safetyTips", db.Text)
    created_at = db.Column("createdAt", db.DateTime, server_default=db.func.now())

    # TODO: add relationships when Review, Favorite and CompletedTrail exist:
    # reviews, favorites, completed_by

    @property
    def image_list(self):
        """Return images as a Python list."""
        return json.loads(self.images) if self.images else []
