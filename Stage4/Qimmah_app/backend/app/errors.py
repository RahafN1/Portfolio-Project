"""Shared API error type and JSON error handlers."""
from flask import jsonify
from werkzeug.exceptions import HTTPException


class APIError(Exception):
    """Raise anywhere to return {"error": message} with a status code."""

    def __init__(self, message, status_code=400):
        super().__init__(message)
        self.message = message
        self.status_code = status_code


def register_error_handlers(app):
    """Return every error as {"error": "..."} (Stage 3 error format)."""

    @app.errorhandler(APIError)
    def handle_api_error(error):
        return jsonify({"error": error.message}), error.status_code

    @app.errorhandler(HTTPException)
    def handle_http_error(error):
        return jsonify({"error": error.description}), error.code

    @app.errorhandler(Exception)
    def handle_unexpected_error(error):
        app.logger.exception(error)
        return jsonify({"error": "Internal server error"}), 500
