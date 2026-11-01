import json

from app.extensions import db


class Trail(db.Model):
    """A hiking trail (UML: Trail)."""
    __tablename__ = "trails"

    # ---------- Attributes ----------
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False, index=True)
    description = db.Column(db.Text)
    region = db.Column(db.String(50), nullable=False, index=True)
    difficulty = db.Column(db.Enum("easy", "moderate", "hard"), nullable=False, index=True)
    distance = db.Column(db.Numeric(5, 2), nullable=False)
    estimated_duration = db.Column("estimatedDuration", db.String(50), nullable=False)
    images = db.Column(db.Text)
    start_latitude = db.Column("startLatitude", db.Numeric(9, 6))
    start_longitude = db.Column("startLongitude", db.Numeric(9, 6))
    end_latitude = db.Column("endLatitude", db.Numeric(9, 6))
    end_longitude = db.Column("endLongitude", db.Numeric(9, 6))
    route_coordinates = db.Column("routeCoordinates", db.JSON)
    safety_tips = db.Column("safetyTips", db.Text)
    created_at = db.Column("createdAt", db.DateTime, server_default=db.func.now())

    # ---------- Relationships ----------
    # TODO: uncomment when Review, Favorite and CompletedTrail models are written
    # reviews = db.relationship("Review", backref="trail",
    #                           cascade="all, delete-orphan", passive_deletes=True)
    # favorites = db.relationship("Favorite", backref="trail",
    #                             cascade="all, delete-orphan", passive_deletes=True)
    # completed_by = db.relationship("CompletedTrail", backref="trail",
    #                                cascade="all, delete-orphan", passive_deletes=True)

    # ---------- Helpers ----------
    @property
    def image_list(self):
        """The images column holds a JSON list as text; return it as a list."""
        return json.loads(self.images) if self.images else []

    @staticmethod
    def _point(lat, lng):
        """Build {"lat", "lng"} or None when the point is not set yet."""
        if lat is None or lng is None:
            return None
        return {"lat": float(lat), "lng": float(lng)}

    def get_average_rating(self):
        """Average of this trail's reviews (1 decimal), or None if no reviews."""
        # import هنا (مو فوق) عشان ما يصير استيراد دائري مع review.py
        from app.models.review import Review

        avg = (db.session.query(db.func.avg(Review.rating))
               .filter(Review.trail_id == self.id)
               .scalar())
        return round(float(avg), 1) if avg is not None else None

    # ---------- Methods (UML) ----------
    def get_location(self):
        """UML: getLocation() — the trail's start and end points."""
        return {
            "start_point": self._point(self.start_latitude, self.start_longitude),
            "end_point": self._point(self.end_latitude, self.end_longitude),
        }

    def get_route(self):
        """UML: getRoute() — the GeoJSON route, or None if not added yet."""
        return self.route_coordinates

    def get_safety_tips(self):
        """UML: getSafetyTips()."""
        return self.safety_tips

    def get_summary(self):
        """Short version for trail lists (endpoint 14) — no full route."""
        images = self.image_list
        return {
            "id": self.id,
            "name": self.name,
            "region": self.region,
            "difficulty": self.difficulty,
            "distance": float(self.distance),
            "estimated_duration": self.estimated_duration,
            "average_rating": self.get_average_rating(),
            "cover_image": images[0] if images else None,
            "start_point": self.get_location()["start_point"],
        }

    def get_details(self):
        """UML: getDetails() — full details for the trail page (endpoint 15)."""
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "region": self.region,
            "difficulty": self.difficulty,
            "distance": float(self.distance),
            "estimated_duration": self.estimated_duration,
            "images": self.image_list,
            **self.get_location(),
            "route_coordinates": self.get_route(),
            "safety_tips": self.get_safety_tips(),
            "average_rating": self.get_average_rating(),
            "created_at": self.created_at.isoformat() + "Z" if self.created_at else None,
        }
