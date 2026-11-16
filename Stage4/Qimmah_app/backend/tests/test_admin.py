import pytest
from werkzeug.security import generate_password_hash

from app.extensions import db
from app.models.admin import Admin
from app.models.review import Review
from app.models.trail import Trail
from app.models.user import User

TRAIL = {
    "name": "Test Trail",
    "description": "A nice trail",
    "region": "Riyadh",
    "difficulty": "easy",
    "distance": 5.5,
    "estimated_duration": "2 hours",
}

ROUTE = {
    "type": "FeatureCollection",
    "features": [{
        "type": "Feature",
        "properties": {},
        "geometry": {"type": "LineString",
                     "coordinates": [[46.60, 24.70], [46.70, 24.80]]},
    }],
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


def create_trail(client, admin_token):
    """Add a trail through the API and return its id."""
    client.post("/api/admin/trails", json=TRAIL, headers=auth(admin_token))
    db.session.expire_all()
    return Trail.query.first().id


def get_user_id(email):
    return User.query.filter_by(email=email).first().id


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


# ---------- 21. PUT /api/admin/trails/{id} ----------

def test_update_trail_success(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.put(f"/api/admin/trails/{trail_id}", json={"name": "New Name"},
                          headers=auth(admin_token))
    assert response.status_code == 200
    db.session.expire_all()
    assert db.session.get(Trail, trail_id).name == "New Name"


def test_update_trail_bad_difficulty(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.put(f"/api/admin/trails/{trail_id}", json={"difficulty": "super"},
                          headers=auth(admin_token))
    assert response.status_code == 400


def test_update_trail_not_found(client, admin_token):
    response = client.put("/api/admin/trails/9999", json={"name": "X"},
                          headers=auth(admin_token))
    assert response.status_code == 404


def test_update_trail_as_normal_user(client, admin_token, user_token):
    trail_id = create_trail(client, admin_token)
    response = client.put(f"/api/admin/trails/{trail_id}", json={"name": "X"},
                          headers=auth(user_token))
    assert response.status_code == 403


# ---------- 22. DELETE /api/admin/trails/{id} ----------

def test_delete_trail_success(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.delete(f"/api/admin/trails/{trail_id}", headers=auth(admin_token))
    assert response.status_code == 200
    db.session.expire_all()
    assert db.session.get(Trail, trail_id) is None


def test_delete_trail_not_found(client, admin_token):
    response = client.delete("/api/admin/trails/9999", headers=auth(admin_token))
    assert response.status_code == 404


def test_delete_trail_as_normal_user(client, admin_token, user_token):
    trail_id = create_trail(client, admin_token)
    response = client.delete(f"/api/admin/trails/{trail_id}", headers=auth(user_token))
    assert response.status_code == 403


# ---------- 23. POST /api/admin/trails/{id}/images ----------

def test_upload_images_success(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.post(f"/api/admin/trails/{trail_id}/images",
                           json={"images": ["https://example.com/a.jpg"]},
                           headers=auth(admin_token))
    assert response.status_code == 200
    assert "https://example.com/a.jpg" in response.get_json()["images"]


def test_upload_images_not_a_list(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.post(f"/api/admin/trails/{trail_id}/images",
                           json={"images": "not-a-list"}, headers=auth(admin_token))
    assert response.status_code == 400


def test_upload_images_empty(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.post(f"/api/admin/trails/{trail_id}/images",
                           json={"images": []}, headers=auth(admin_token))
    assert response.status_code == 400


def test_upload_images_trail_not_found(client, admin_token):
    response = client.post("/api/admin/trails/9999/images",
                           json={"images": ["https://example.com/a.jpg"]},
                           headers=auth(admin_token))
    assert response.status_code == 404


# ---------- 24. PUT /api/admin/trails/{id}/route ----------

def test_update_route_success(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.put(f"/api/admin/trails/{trail_id}/route",
                          json={"route_coordinates": ROUTE}, headers=auth(admin_token))
    assert response.status_code == 200


def test_update_route_invalid(client, admin_token):
    trail_id = create_trail(client, admin_token)
    response = client.put(f"/api/admin/trails/{trail_id}/route",
                          json={"route_coordinates": {"type": "Point"}},
                          headers=auth(admin_token))
    assert response.status_code == 400


def test_update_route_trail_not_found(client, admin_token):
    response = client.put("/api/admin/trails/9999/route",
                          json={"route_coordinates": ROUTE}, headers=auth(admin_token))
    assert response.status_code == 404


# ---------- 25. DELETE /api/admin/reviews/{id} ----------

def test_delete_review_success(client, admin_token, user_token):
    trail_id = create_trail(client, admin_token)
    user_id = get_user_id("user@example.com")
    review = Review(user_id=user_id, trail_id=trail_id, rating=5, comment="Great trail")
    db.session.add(review)
    db.session.commit()
    review_id = review.id

    response = client.delete(f"/api/admin/reviews/{review_id}", headers=auth(admin_token))
    assert response.status_code == 200
    db.session.expire_all()
    assert db.session.get(Review, review_id) is None


def test_delete_review_not_found(client, admin_token):
    response = client.delete("/api/admin/reviews/9999", headers=auth(admin_token))
    assert response.status_code == 404


def test_delete_review_as_normal_user(client, user_token):
    response = client.delete("/api/admin/reviews/1", headers=auth(user_token))
    assert response.status_code == 403


# ---------- 26. PATCH /api/admin/users/{id}/suspend ----------

def test_suspend_user_success(client, admin_token, user_token):
    user_id = get_user_id("user@example.com")
    response = client.patch(f"/api/admin/users/{user_id}/suspend", headers=auth(admin_token))
    assert response.status_code == 200
    db.session.expire_all()
    assert db.session.get(User, user_id).is_suspended is True


def test_suspend_yourself(client, admin_token):
    admin_id = get_user_id("admin@example.com")
    response = client.patch(f"/api/admin/users/{admin_id}/suspend", headers=auth(admin_token))
    assert response.status_code == 400


def test_suspend_user_not_found(client, admin_token):
    response = client.patch("/api/admin/users/9999/suspend", headers=auth(admin_token))
    assert response.status_code == 404


def test_suspend_as_normal_user(client, admin_token, user_token):
    admin_id = get_user_id("admin@example.com")
    response = client.patch(f"/api/admin/users/{admin_id}/suspend", headers=auth(user_token))
    assert response.status_code == 403


def test_suspended_user_is_blocked(client, admin_token, user_token):
    """After suspension, the user's old token stops working."""
    user_id = get_user_id("user@example.com")
    client.patch(f"/api/admin/users/{user_id}/suspend", headers=auth(admin_token))
    response = client.get("/api/users/me", headers=auth(user_token))
    assert response.status_code == 403