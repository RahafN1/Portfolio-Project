from flask_jwt_extended import create_access_token

from app import create_app
from app.config import TestConfig  # عدلي المسار لو TestConfig في مكان ثاني
from app.extensions import db


def make_app():
    app = create_app(TestConfig)
    with app.app_context():
        db.create_all()
    return app


def test_logout_with_token():
    app = make_app()
    with app.app_context():
        token = create_access_token(identity="1")
    client = app.test_client()
    res = client.post("/api/auth/logout", headers={"Authorization": f"Bearer {token}"})
    assert res.status_code == 200


def test_token_revoked_after_logout():
    app = make_app()
    with app.app_context():
        token = create_access_token(identity="1")
    client = app.test_client()
    headers = {"Authorization": f"Bearer {token}"}

    assert client.post("/api/auth/logout", headers=headers).status_code == 200
    assert client.post("/api/auth/logout", headers=headers).status_code == 401
