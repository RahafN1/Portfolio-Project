"""Shared pytest fixtures: the app on a temporary test database."""
import json
import os
import sys

import pytest

TESTS_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.abspath(os.path.join(TESTS_DIR, ".."))

if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from app import create_app  # noqa: E402
from app.config import TestConfig  # noqa: E402
from app.extensions import db as _db  # noqa: E402
from app.models import Trail  # noqa: E402


def make_trail(name, difficulty):
    return Trail(
        name=name, description="وصف", region="الغاط", difficulty=difficulty,
        distance=2.5, estimated_duration="ساعة",
        images=json.dumps(["https://example.com/a.jpg"]),
        start_latitude=26.0, start_longitude=45.0,
        end_latitude=26.1, end_longitude=45.1,
        route_coordinates={"type": "FeatureCollection", "features": []},
    )


@pytest.fixture(scope="session")
def app():
    app = create_app(TestConfig)
    yield app


@pytest.fixture(scope="function")
def db(app):
    with app.app_context():
        _db.create_all()
        _db.session.add_all([make_trail("مسار سهل", "easy"),
                             make_trail("مسار صعب", "hard")])
        _db.session.commit()
        yield _db
        _db.session.rollback()
        _db.drop_all()


@pytest.fixture(scope="function")
def client(app, db):
    return app.test_client()