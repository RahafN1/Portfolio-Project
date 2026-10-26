from app.errors import APIError
from app.models import Trail

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

    @classmethod
    def find_trails(cls, search=None, region=None, difficulty=None, page=1, limit=20):
        """Combine search + filters + pagination (endpoint 14).
        Returns (trails, total)."""
        if page < 1 or not 1 <= limit <= 100:
            raise APIError("page must be >= 1 and limit between 1 and 100", 400)
        query = Trail.query
        if search:
            query = cls.search_by_name(search, query)
        if region:
            query = cls.filter_by_region(region, query)
        if difficulty:
            query = cls.filter_by_difficulty(difficulty, query)
        total = query.count()
        trails = query.order_by(Trail.id).offset((page - 1) * limit).limit(limit).all()
        return trails, total
