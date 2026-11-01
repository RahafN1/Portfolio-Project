from flask import Blueprint, jsonify

health_bp = Blueprint("health", __name__)


@health_bp.get("/health")
def health():
    """Simple check that the API is running."""
    return jsonify({"status": "ok"})
