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


@pytest.fixture(scope="session")
def app():
    app = create_app(TestConfig)
    yield app


@pytest.fixture(scope="function")
def db(app):
    with app.app_context():
        _db.create_all()
        yield _db
        _db.session.rollback()
        _db.drop_all()


@pytest.fixture(scope="function")
def client(app, db):
    return app.test_client()