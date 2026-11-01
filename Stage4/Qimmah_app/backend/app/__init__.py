from flask import Flask
from flask_cors import CORS

from app.config import Config
from app.extensions import db, migrate, jwt
from flasgger import Swagger


def create_app(config_class=Config):
    """Create and configure the Flask application."""
    app = Flask(__name__)
    app.config.from_object(config_class)
    app.json.ensure_ascii = False

    swagger_template = {
        "securityDefinitions": {
            "Bearer": {
                "type": "apiKey",
                "name": "Authorization",
                "in": "header",
                "description": "Enter: Bearer <your token>"
            }
        }
    }
    Swagger(app, template=swagger_template)

    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    CORS(app)

    from app.errors import register_error_handlers
    register_error_handlers(app)

    from app import models  # noqa: F401  (so Flask-Migrate sees every table)

    from app.routes.health import health_bp
    app.register_blueprint(health_bp, url_prefix="/api")

    from app.routes.trails import trails_bp
    app.register_blueprint(trails_bp, url_prefix="/api/trails")

    from app.routes.auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix="/api/auth")

    from app.routes.users import users_bp
    app.register_blueprint(users_bp, url_prefix="/api/users")

    from app.routes.reviews import reviews_bp
    app.register_blueprint(reviews_bp, url_prefix="/api")

    from app.routes.admin import admin_bp
    app.register_blueprint(admin_bp, url_prefix="/api/admin")

    return app