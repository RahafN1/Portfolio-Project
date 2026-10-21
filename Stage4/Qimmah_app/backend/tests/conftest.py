"""Shared pytest fixtures: the app on a temporary in-memory database."""
import json

import pytest

from app import create_app
from app.config import Config
from app.extensions import db
from app.models import Trail


class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    SQLALCHEMY_ENGINE_OPTIONS = {}


def make_trail(name, difficulty):
    return Trail(
        name=name, description="وصف", region="الغاط", difficulty=difficulty,
        distance=2.5, estimated_duration="ساعة",
        images=json.dumps(["https://example.com/a.jpg"]),
        start_latitude=26.0, start_longitude=45.0,
        end_latitude=26.1, end_longitude=45.1,
        route_coordinates={"type": "FeatureCollection", "features": []},
    )


@pytest.fixture
def app():
    app = create_app(TestingConfig)
    with app.app_context():
        db.create_all()
        db.session.add_all([make_trail("مسار سهل", "easy"),
                            make_trail("مسار صعب", "hard")])
        db.session.commit()
        yield app
        db.session.remove()
        db.drop_all()


@pytest.fixture
def client(app):
    return app.test_client()
