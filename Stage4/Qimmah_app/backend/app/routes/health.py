from flask import Blueprint, jsonify

health_bp = Blueprint("health", __name__)


@health_bp.get("/health")
def health():
    """Health check
    ---
    tags:
      - Health
    summary: Check that the API is running
    description: Lightweight endpoint for monitoring and load balancers.
    responses:
      200:
        description: The API is up
        schema:
          type: object
          properties:
            status:
              type: string
              example: ok
    """
    return jsonify({"status": "ok"})
