"""Tests for the reviews endpoints (7, 16, 17, 18, 19)."""
import pytest
from werkzeug.security import generate_password_hash

from app.models import Trail
from app.models.user import User

MY_REVIEWS_URL = "/api/users/me/reviews"


def make_user(db, email="sara@example.com"):
    user = User(name="Sara", email=email,
                password=generate_password_hash("StrongPass123"),
                is_verified=True)
    db.session.add(user)
    db.session.commit()
    return user


def auth(user):
    return {"Authorization": f"Bearer {user.create_token()}"}


@pytest.fixture
def user(db):
    return make_user(db)


@pytest.fixture
def other_user(db):
    return make_user(db, email="other@example.com")


@pytest.fixture
def trail_id(db):
    return Trail.query.first().id


def trail_url(trail_id):
    return f"/api/trails/{trail_id}/reviews"


def post_review(client, user, trail_id, rating=5, comment="مسار رائع"):
    """دالة مساعدة: ترسل تقييم وترجع الرد."""
    return client.post(trail_url(trail_id),
                       json={"rating": rating, "comment": comment},
                       headers=auth(user))


# ---------- Endpoint 17: POST ----------

def test_add_review_requires_token(client, trail_id):
    r = client.post(trail_url(trail_id), json={"rating": 5, "comment": "x"})
    assert r.status_code == 401


def test_add_review(client, user, trail_id):
    r = post_review(client, user, trail_id)
    assert r.status_code == 201
    body = r.get_json()
    assert body["rating"] == 5
    assert body["comment"] == "مسار رائع"


def test_add_review_trail_not_found(client, user):
    r = post_review(client, user, 9999)
    assert r.status_code == 404


@pytest.mark.parametrize("bad_rating", [0, 6, -1])
def test_add_review_invalid_rating(client, user, trail_id, bad_rating):
    r = post_review(client, user, trail_id, rating=bad_rating)
    assert r.status_code == 400


def test_add_review_empty_comment(client, user, trail_id):
    r = post_review(client, user, trail_id, comment="   ")
    assert r.status_code == 400


# ---------- Endpoint 16: GET (public) ----------

def test_get_reviews_no_token_needed(client, trail_id):
    r = client.get(trail_url(trail_id))
    assert r.status_code == 200
    body = r.get_json()
    assert body["average_rating"] is None
    assert body["reviews"] == []
    assert body["total"] == 0


def test_get_reviews_trail_not_found(client):
    r = client.get(trail_url(9999))
    assert r.status_code == 404


def test_get_reviews_with_user_and_average(client, user, other_user,
                                           trail_id):
    post_review(client, user, trail_id, rating=5)
    post_review(client, other_user, trail_id, rating=3)

    r = client.get(trail_url(trail_id))
    assert r.status_code == 200
    body = r.get_json()
    assert body["average_rating"] == 4.0
    assert body["total"] == 2
    assert body["page"] == 1
    assert body["reviews"][0]["user"]["name"] == "Sara"
    assert "id" in body["reviews"][0]["user"]


def test_get_reviews_pagination(client, db, trail_id):
    for i in range(3):
        u = make_user(db, email=f"user{i}@example.com")
        post_review(client, u, trail_id, rating=4)

    page1 = client.get(f"{trail_url(trail_id)}?page=1&limit=2").get_json()
    page2 = client.get(f"{trail_url(trail_id)}?page=2&limit=2").get_json()

    assert page1["total"] == 3
    assert len(page1["reviews"]) == 2
    assert len(page2["reviews"]) == 1


# ---------- Endpoint 18: PUT ----------

def test_update_review_requires_token(client, user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.put(f"/api/reviews/{review_id}", json={"rating": 4})
    assert r.status_code == 401


def test_update_review(client, user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.put(f"/api/reviews/{review_id}",
                   json={"rating": 4, "comment": "جميل لكنه مزدحم"},
                   headers=auth(user))
    assert r.status_code == 200
    body = r.get_json()
    assert body["rating"] == 4
    assert body["comment"] == "جميل لكنه مزدحم"


def test_update_review_not_owner(client, user, other_user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.put(f"/api/reviews/{review_id}", json={"rating": 1},
                   headers=auth(other_user))
    assert r.status_code == 403


def test_update_review_not_found(client, user):
    r = client.put("/api/reviews/9999", json={"rating": 4},
                   headers=auth(user))
    assert r.status_code == 404


def test_update_review_empty_body(client, user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.put(f"/api/reviews/{review_id}", json={},
                   headers=auth(user))
    assert r.status_code == 400


def test_update_review_invalid_rating(client, user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.put(f"/api/reviews/{review_id}", json={"rating": 9},
                   headers=auth(user))
    assert r.status_code == 400


# ---------- Endpoint 19: DELETE ----------

def test_delete_review_requires_token(client, user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.delete(f"/api/reviews/{review_id}")
    assert r.status_code == 401


def test_delete_review(client, user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.delete(f"/api/reviews/{review_id}", headers=auth(user))
    assert r.status_code == 204

    # نتأكد إنه انحذف فعلًا
    body = client.get(trail_url(trail_id)).get_json()
    assert body["total"] == 0


def test_delete_review_not_owner(client, user, other_user, trail_id):
    review_id = post_review(client, user, trail_id).get_json()["id"]
    r = client.delete(f"/api/reviews/{review_id}", headers=auth(other_user))
    assert r.status_code == 403


def test_delete_review_not_found(client, user):
    r = client.delete("/api/reviews/9999", headers=auth(user))
    assert r.status_code == 404


# ---------- Endpoint 7: my reviews ----------

def test_my_reviews_requires_token(client):
    assert client.get(MY_REVIEWS_URL).status_code == 401


def test_my_reviews(client, user, trail_id):
    post_review(client, user, trail_id)
    r = client.get(MY_REVIEWS_URL, headers=auth(user))
    assert r.status_code == 200
    body = r.get_json()
    assert body["total"] == 1
    assert body["reviews"][0]["trail"]["id"] == trail_id
    assert "name" in body["reviews"][0]["trail"]


def test_my_reviews_only_own(client, user, other_user, trail_id):
    post_review(client, other_user, trail_id)
    r = client.get(MY_REVIEWS_URL, headers=auth(user))
    assert r.get_json()["total"] == 0


# ---------- average_rating في ملخص المسار وتفاصيله ----------

def test_trail_average_rating(client, db, user, other_user, trail_id):
    trail = db.session.get(Trail, trail_id)
    assert trail.get_summary()["average_rating"] is None

    post_review(client, user, trail_id, rating=5)
    post_review(client, other_user, trail_id, rating=4)

    assert trail.get_summary()["average_rating"] == 4.5
    assert trail.get_details()["average_rating"] == 4.5
