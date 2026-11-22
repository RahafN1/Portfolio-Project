"""Trails module — Stage 3 endpoints.

14. GET /api/trails          🌐  search · filter by region / difficulty · pagination
15. GET /api/trails/{id}     🌐  details + route + start/end points 
"""
from flask import Blueprint, jsonify, request

from app.services.trail_service import TrailService

trails_bp = Blueprint("trails", __name__)


@trails_bp.route("", methods=["GET"])
def get_trails():
    """Endpoint 14 — trail list (summary only), open to guests.
    ---
    tags:
      - Trails
    parameters:
      - in: query
        name: search
        type: string
        required: false
        description: Search by trail name
      - in: query
        name: region
        type: string
        required: false
        description: Filter by region
      - in: query
        name: difficulty
        type: string
        required: false
        description: Filter by difficulty
      - in: query
        name: page
        type: integer
        required: false
        default: 1
      - in: query
        name: limit
        type: integer
        required: false
        default: 20
      - in: query
        name: lang
        type: string
        required: false
        default: ar
    responses:
      200:
        description: A list of trails with the total count
    """
    page = request.args.get("page", 1, type=int)
    lang = request.args.get("lang", "ar")
    trails, total = TrailService.find_trails(
        search=request.args.get("search"),
        region=request.args.get("region"),
        difficulty=request.args.get("difficulty"),
        page=page,
        limit=request.args.get("limit", 20, type=int),
    )
    ratings = TrailService.average_ratings(trails)  # استعلام واحد لكل المسارات
    return jsonify({
        "trails": [trail.get_summary(lang, ratings.get(trail.id)) for trail in trails],
        "page": page,
        "total": total,
    }), 200


@trails_bp.route("/<int:trail_id>", methods=["GET"])
def get_trail(trail_id):
    """Endpoint 15 — full trail details (route + start/end points), open to guests.
    ---
    tags:
      - Trails
    parameters:
      - in: path
        name: trail_id
        type: integer
        required: true
        description: The trail's ID
      - in: query
        name: lang
        type: string
        required: false
        default: ar
    responses:
      200:
        description: Full trail details
      404:
        description: Trail not found
    """
    trail = TrailService.get_trail_by_id(trail_id)
    lang = request.args.get("lang", "ar")
    return jsonify(trail.get_details(lang)), 200
