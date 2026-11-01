import json

from app.errors import APIError
from app.extensions import db
from app.models.trail import Trail
from app.models.user import User

DIFFICULTIES = ("easy", "moderate", "hard")
REQUIRED_TRAIL_FIELDS = ("name", "description", "region", "difficulty",
                         "distance", "estimated_duration")


class Admin(User):
    """An admin (UML: Admin inherits from User).

    Stored in the same users table, with role = 'admin'.
    """
    __mapper_args__ = {"polymorphic_identity": "admin"}

    # ---------- Helpers ----------
    @staticmethod
    def _get_trail(trail_id):
        trail = db.session.get(Trail, trail_id)
        if trail is None:
            raise APIError("Trail not found", 404)
        return trail

    @staticmethod
    def _validate_route(route):
        """The route must be a GeoJSON FeatureCollection with a LineString.
        Returns the line's coordinates as [[lng, lat], ...]."""
        if isinstance(route, str):
            try:
                route = json.loads(route)
            except ValueError:
                raise APIError("Invalid GeoJSON", 400)
        if not isinstance(route, dict) or route.get("type") != "FeatureCollection":
            raise APIError("Invalid GeoJSON: expected a FeatureCollection", 400)
        for feature in route.get("features") or []:
            geometry = (feature or {}).get("geometry") or {}
            coords = geometry.get("coordinates")
            if geometry.get("type") == "LineString" and coords and len(coords) >= 2:
                return route, coords
        raise APIError("Invalid GeoJSON: the route must contain a LineString", 400)

    @staticmethod
    def _apply_trail_fields(trail, data):
        """Copy the allowed fields from data into the trail, with validation."""
        if "name" in data:
            name = (data["name"] or "").strip()
            if not name:
                raise APIError("name cannot be empty", 400)
            trail.name = name
        if "description" in data:
            trail.description = data["description"]
        if "region" in data:
            region = (data["region"] or "").strip()
            if not region:
                raise APIError("region cannot be empty", 400)
            trail.region = region
        if "difficulty" in data:
            if data["difficulty"] not in DIFFICULTIES:
                raise APIError("difficulty must be easy, moderate or hard", 400)
            trail.difficulty = data["difficulty"]
        if "distance" in data:
            try:
                distance = float(data["distance"])
            except (TypeError, ValueError):
                raise APIError("distance must be a number", 400)
            if distance <= 0:
                raise APIError("distance must be greater than 0", 400)
            trail.distance = distance
        if "estimated_duration" in data:
            duration = (data["estimated_duration"] or "").strip()
            if not duration:
                raise APIError("estimated_duration cannot be empty", 400)
            trail.estimated_duration = duration
        if "safety_tips" in data:
            trail.safety_tips = data["safety_tips"]

    def _set_route(self, trail, route_coordinates):
        """Save the route and take the start/end points from the line."""
        route, coords = self._validate_route(route_coordinates)
        trail.route_coordinates = route
        trail.start_longitude, trail.start_latitude = coords[0][0], coords[0][1]
        trail.end_longitude, trail.end_latitude = coords[-1][0], coords[-1][1]

    # ---------- Methods (UML) ----------
    def add_trail(self, trail_data):
        """UML: addTrail(trailData) — create a trail (endpoint 20)."""
        missing = [f for f in REQUIRED_TRAIL_FIELDS if not trail_data.get(f)]
        if missing:
            raise APIError(f"Missing fields: {', '.join(missing)}", 400)

        trail = Trail()
        self._apply_trail_fields(trail, trail_data)
        trail.images = json.dumps(trail_data.get("images") or [])
        db.session.add(trail)
        if trail_data.get("route_coordinates"):
            self._set_route(trail, trail_data["route_coordinates"])
        db.session.commit()
        return trail

    def update_trail(self, trail_id, trail_data):
        """UML: updateTrail(trailId, trailData) — change trail info (endpoint 21)."""
        trail = self._get_trail(trail_id)
        self._apply_trail_fields(trail, trail_data)
        db.session.commit()
        return trail

    def delete_trail(self, trail_id):
        """UML: deleteTrail(trailId) — its reviews, favorites and completions
        are deleted too (ON DELETE CASCADE). (endpoint 22)"""
        trail = self._get_trail(trail_id)
        # TODO: also delete the trail's photos from Cloudinary
        db.session.delete(trail)
        db.session.commit()

    def upload_trail_images(self, trail_id, images):
        """UML: uploadTrailImages(trailId, images) — add image URLs (endpoint 23).
        The files are uploaded to Cloudinary first; here we save their URLs."""
        trail = self._get_trail(trail_id)
        if not images:
            raise APIError("No images provided", 400)
        trail.images = json.dumps(trail.image_list + list(images))
        db.session.commit()
        return trail.image_list

    def update_trail_route(self, trail_id, route_coordinates):
        """UML: updateTrailRoute(trailId, routeCoordinates) (endpoint 24)."""
        trail = self._get_trail(trail_id)
        self._set_route(trail, route_coordinates)
        db.session.commit()
        return trail

    def suspend_user(self, user_id):
        """UML: suspendUser(userId) (endpoint 26)."""
        user = db.session.get(User, user_id)
        if user is None:
            raise APIError("User not found", 404)
        if user.id == self.id:
            raise APIError("You cannot suspend your own account", 400)
        if user.role == "admin":
            raise APIError("Admins cannot be suspended", 400)
        user.is_suspended = True
        db.session.commit()
        return user

    def get_stats(self):
        """Dashboard counters (endpoint 27)."""
        from app.models.review import Review
        return {
            "trails": Trail.query.count(),
            "reviews": Review.query.count(),
            "users": User.query.filter(User.role == "user").count(),
        }

    def list_users(self, page, limit):
        """Regular users with their reviews count (endpoint 28)."""
        from sqlalchemy import func
        from app.models.review import Review

        query = User.query.filter(User.role == "user")
        total = query.count()
        users = (query.order_by(User.id.desc())
                 .offset((page - 1) * limit).limit(limit).all())

        counts = dict(
            db.session.query(Review.user_id, func.count(Review.id))
            .group_by(Review.user_id).all()
        )
        data = []
        for user in users:
            item = user.to_dict()
            item["is_suspended"] = user.is_suspended
            item["reviews_count"] = counts.get(user.id, 0)
            data.append(item)
        return data, total

    def list_reviews(self, page, limit):
        """All reviews with the author and trail names (endpoint 29)."""
        from app.models.review import Review

        total = Review.query.count()
        rows = (
            db.session.query(Review, User, Trail)
            .join(User, Review.user_id == User.id)
            .join(Trail, Review.trail_id == Trail.id)
            .order_by(Review.created_at.desc())
            .offset((page - 1) * limit).limit(limit).all()
        )
        data = []
        for review, user, trail in rows:
            item = review.to_dict()
            item["user"] = {"id": user.id, "name": user.name}
            item["trail"] = {"id": trail.id, "name": trail.name}
            data.append(item)
        return data, total

    def unsuspend_user(self, user_id):
        """Lift a suspension (endpoint 30)."""
        user = db.session.get(User, user_id)
        if user is None:
            raise APIError("User not found", 404)
        user.is_suspended = False
        db.session.commit()
        return user
    
    def delete_review(self, review_id):
        """UML: deleteReview(reviewId) (endpoint 25)."""
        from app.models.review import Review
        review = db.session.get(Review, review_id)
        if review is None:
            raise APIError("Review not found", 404)
        db.session.delete(review)
        db.session.commit()