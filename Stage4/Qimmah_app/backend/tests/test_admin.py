import pytest
from werkzeug.security import generate_password_hash

from app.extensions import db
from app.models.admin import Admin
from app.models.user import User

TRAIL = {
    "name": "Test Trail",
    "description": "A nice trail",
    "region": "Riyadh",
    "difficulty": "easy",
    "distance": 5.5,
    "estimated_duration": "2 hours",
}


# ---------- Helpers ----------

def make_account(cls, email):
    """Create a verified account (User or Admin) and return its token."""
    account = cls(name="Test", email=email,
                  password=generate_password_hash("Password123!"),
                  is_verified=True)
    db.session.add(account)
    db.session.commit()
    return account.create_token()


@pytest.fixture
def admin_token(client):
    return make_account(Admin, "admin@example.com")


@pytest.fixture
def user_token(client):
    return make_account(User, "user@example.com")


def auth(token):
    return {"Authorization": f"Bearer {token}"}


# ---------- 20. POST /api/admin/trails ----------

def test_add_trail_success(client, admin_token):
    response = client.post("/api/admin/trails", json=TRAIL, headers=auth(admin_token))
    assert response.status_code == 201
    assert "trail" in response.get_json()


def test_add_trail_without_token(client):
    response = client.post("/api/admin/trails", json=TRAIL)
    assert response.status_code == 401


def test_add_trail_as_normal_user(client, user_token):
    response = client.post("/api/admin/trails", json=TRAIL, headers=auth(user_token))
    assert response.status_code == 403


def test_add_trail_missing_fields(client, admin_token):
    response = client.post("/api/admin/trails", json={"name": "Only a name"},
                           headers=auth(admin_token))
    assert response.status_code == 400


def test_add_trail_bad_difficulty(client, admin_token):
    response = client.post("/api/admin/trails", json={**TRAIL, "difficulty": "super"},
                           headers=auth(admin_token))
    assert response.status_code == 400