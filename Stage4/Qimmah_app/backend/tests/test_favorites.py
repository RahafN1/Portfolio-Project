"""Tests for the favorites endpoints (8, 9, 10)."""
import pytest
from werkzeug.security import generate_password_hash

from app.models import Trail
from app.models.user import User

URL = "/api/users/me/favorites"


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
def trail_id(db):
    return Trail.query.first().id


def test_requires_token(client):
    assert client.get(URL).status_code == 401


def test_add_favorite(client, user, trail_id):
    r = client.post(URL, json={"trail_id": trail_id}, headers=auth(user))
    assert r.status_code == 201
    assert r.get_json()["trail_id"] == trail_id


def test_add_favorite_trail_not_found(client, user):
    r = client.post(URL, json={"trail_id": 9999}, headers=auth(user))
    assert r.status_code == 404


def test_add_favorite_twice(client, user, trail_id):
    client.post(URL, json={"trail_id": trail_id}, headers=auth(user))
    r = client.post(URL, json={"trail_id": trail_id}, headers=auth(user))
    assert r.status_code == 409


def test_add_favorite_invalid_id(client, user):
    r = client.post(URL, json={"trail_id": "abc"}, headers=auth(user))
    assert r.status_code == 400


def test_list_favorites(client, user, trail_id):
    client.post(URL, json={"trail_id": trail_id}, headers=auth(user))
    r = client.get(URL, headers=auth(user))
    assert r.status_code == 200
    body = r.get_json()
    assert body["total"] == 1
    assert body["trails"][0]["id"] == trail_id


def test_list_favorites_only_own(client, db, user, trail_id):
    other = make_user(db, email="other@example.com")
    client.post(URL, json={"trail_id": trail_id}, headers=auth(other))
    r = client.get(URL, headers=auth(user))
    assert r.get_json()["total"] == 0


def test_remove_favorite(client, user, trail_id):
    client.post(URL, json={"trail_id": trail_id}, headers=auth(user))
    r = client.delete(f"{URL}/{trail_id}", headers=auth(user))
    assert r.status_code == 204


def test_remove_favorite_not_saved(client, user, trail_id):
    r = client.delete(f"{URL}/{trail_id}", headers=auth(user))
    assert r.status_code == 404
