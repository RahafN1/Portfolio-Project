"""Trails module — Stage 3 endpoints (to be built).

14. GET /api/trails        🌐  search · filter by region / difficulty · pagination
15. GET /api/trails/{id}   🌐  details + route + start/end points
"""
from flask import Blueprint

trails_bp = Blueprint("trails", __name__)
