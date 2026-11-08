from sqlalchemy import func
from sqlalchemy.orm import defer

from app.errors import APIError
from app.extensions import db
from app.models import Review, Trail

DIFFICULTIES = ("easy", "moderate", "hard")


class TrailService:
    """Search and filter trails (UML: TrailService)."""

    @staticmethod
    def search_by_name(name, query=None):
        """UML: searchByName(name)."""
        query = query if query is not None else Trail.query
        return query.filter(Trail.name.contains(name))

    @staticmethod
    def filter_by_region(region, query=None):
        """UML: filterByRegion(region)."""
        query = query if query is not None else Trail.query
        return query.filter(Trail.region == region)

    @staticmethod
    def filter_by_difficulty(difficulty, query=None):
        """UML: filterByDifficulty(difficulty)."""
        if difficulty not in DIFFICULTIES:
            raise APIError("difficulty must be easy, moderate or hard", 400)
        query = query if query is not None else Trail.query
        return query.filter(Trail.difficulty == difficulty)

    
    @staticmethod
    def get_trail_by_id(trail_id):
        """Endpoint 15 — one trail by its id, or 404 if it doesn't exist."""
        trail = Trail.query.filter_by(id=trail_id).first()
        if trail is None:
            raise APIError("Trail not found", 404)
        return trail 
        
    @classmethod
    def find_trails(cls, search=None, region=None, difficulty=None, page=1, limit=20):
        """Combine search + filters + pagination (endpoint 14).
        Returns (trails, total)."""
        if page < 1 or not 1 <= limit <= 100:
            raise APIError("page must be >= 1 and limit between 1 and 100", 400)
                # القائمة ما تعرض المسار الكامل ولا الوصف، فنأجّل تحميل الأعمدة الثقيلة
        query = Trail.query.options(
            defer(Trail.route_coordinates),
            defer(Trail.description),
            defer(Trail.description_en),
            defer(Trail.safety_tips),
            defer(Trail.safety_tips_en),
        )
        if search:
            query = cls.search_by_name(search, query)
        if region:
            query = cls.filter_by_region(region, query)
        if difficulty:
            query = cls.filter_by_difficulty(difficulty, query)
        total = query.count()
        trails = query.order_by(Trail.id).offset((page - 1) * limit).limit(limit).all()
        return trails, total
           
    @staticmethod
    def average_ratings(trails):
        """متوسط التقييم لكل المسارات في استعلام واحد بدل استعلام لكل مسار.
        Returns {trail_id: average (1 decimal)}; trails with no reviews are absent."""
        ids = [trail.id for trail in trails]
        if not ids:
            return {}
        rows = (db.session.query(Review.trail_id, func.avg(Review.rating))
                .filter(Review.trail_id.in_(ids))
                .group_by(Review.trail_id)
                .all())
        return {trail_id: round(float(avg), 1) for trail_id, avg in rows}
