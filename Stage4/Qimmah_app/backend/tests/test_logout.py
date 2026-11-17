from flask_jwt_extended import create_access_token

from app import create_app
from app.config import TestConfig


def test_logout_with_token():
    app = create_app(TestConfig)
    with app.app_context():
        token = create_access_token(identity="1")
    client = app.test_client()
    res = client.post("/api/auth/logout", headers={"Authorization": f"Bearer {token}"})
    assert res.status_code == 200


def test_logout_without_token():
    app = create_app(TestConfig)
    client = app.test_client()
    res = client.post("/api/auth/logout")
    assert res.status_code == 401
