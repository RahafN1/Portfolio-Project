"""Trails module — Stage 3 endpoints.

14. GET /api/trails          🌐  search · filter by region / difficulty · pagination
15. GET /api/trails/{id}     🌐  details + route + start/end points (to be built)
"""
from flask import Blueprint, jsonify, request

from app.services.trail_service import TrailService

trails_bp = Blueprint("trails", __name__)


@trails_bp.route("", methods=["GET"])
def get_trails():
    """Endpoint 14 — trail list (summary only), open to guests."""
    page = request.args.get("page", 1, type=int)
    trails, total = TrailService.find_trails(
        search=request.args.get("search"),
        region=request.args.get("region"),
        difficulty=request.args.get("difficulty"),
        page=page,
        limit=request.args.get("limit", 20, type=int),
    )
    return jsonify({
        "trails": [trail.get_summary() for trail in trails],
        "page": page,
        "total": total,
    }), 200
