"""Reviews module — Stage 3 endpoints 16-19 (to be built).

16. GET    /api/trails/{id}/reviews   🌐
17. POST   /api/trails/{id}/reviews   🔒
18. PUT    /api/reviews/{id}          🔒  (owner only)
19. DELETE /api/reviews/{id}          🔒  (owner only)
"""
from flask import Blueprint

reviews_bp = Blueprint("reviews", __name__)
