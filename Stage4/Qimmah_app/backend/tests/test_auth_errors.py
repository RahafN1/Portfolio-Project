from datetime import timedelta
from unittest.mock import patch

import pytest

from app.errors import APIError
from app.extensions import db
from app.models.user import User

USER = {
    "name": "Zahra",
    "email": "zahra@example.com",
    "password": "Password123!",
}


# ---------- Helpers ----------

@pytest.fixture
def mock_send():
    """Replace the email function so no real email is sent."""
    with patch("app.models.user.send_otp_email") as fake:
        yield fake


def register(client, mock_send):
    """Register USER and return the code that was 'sent'."""
    client.post("/api/auth/register", json=USER)

    return mock_send.call_args.args[1]


def register_and_verify(client, mock_send):
    code = register(client, mock_send)
    client.post("/api/auth/verify-email", json={"email": USER["email"], "code": code})


def get_user():
    """Read the user fresh from the database."""
    db.session.expire_all()
    return User.query.filter_by(email=USER["email"]).first()


def wrong_code(code):
    return "000000" if code != "000000" else "111111"


# ---------- Register ----------

def test_register_missing_name(client, mock_send):
    response = client.post("/api/auth/register", json={**USER, "name": ""})
    assert response.status_code == 400
    assert "error" in response.get_json()
    mock_send.assert_not_called()


def test_register_invalid_email(client, mock_send):
    response = client.post("/api/auth/register", json={**USER, "email": "not-an-email"})
    assert response.status_code == 400


def test_register_short_password(client, mock_send):
    response = client.post("/api/auth/register", json={**USER, "password": "123"})
    assert response.status_code == 400


def test_register_verified_email_again(client, mock_send):
    register_and_verify(client, mock_send)
    response = client.post("/api/auth/register", json=USER)
    assert response.status_code == 409


def test_register_unverified_email_again(client, mock_send):
    register(client, mock_send)
    response = client.post("/api/auth/register", json=USER)
    assert response.status_code == 201
    assert mock_send.call_count == 2


def test_register_when_email_fails(client, mock_send):
    mock_send.side_effect = APIError("Could not send the verification code", 502)
    response = client.post("/api/auth/register", json=USER)
    assert response.status_code == 502
    assert get_user() is not None

def test_register_password_missing_uppercase(client, mock_send):
    response = client.post("/api/auth/register", json={**USER, "password": "password123"})
    assert response.status_code == 400
    assert "error" in response.get_json()
    mock_send.assert_not_called()


def test_register_password_missing_lowercase(client, mock_send):
    response = client.post("/api/auth/register", json={**USER, "password": "PASSWORD123"})
    assert response.status_code == 400
    assert "error" in response.get_json()
    mock_send.assert_not_called()


def test_register_password_missing_digit(client, mock_send):
    response = client.post("/api/auth/register", json={**USER, "password": "PasswordABC"})
    assert response.status_code == 400
    assert "error" in response.get_json()
    mock_send.assert_not_called()


def test_register_password_too_long(client, mock_send):
    too_long = "A1a" + ("b" * 127)
    response = client.post("/api/auth/register", json={**USER, "password": too_long})
    assert response.status_code == 400
    assert "error" in response.get_json()
    mock_send.assert_not_called()
    
# ---------- Verify email ----------

def test_verify_wrong_code(client, mock_send):
    code = register(client, mock_send)
    response = client.post("/api/auth/verify-email",
                           json={"email": USER["email"], "code": wrong_code(code)})
    assert response.status_code == 400
    assert get_user().otp_attempts == 1


def test_verify_expired_code(client, mock_send):
    code = register(client, mock_send)
    user = get_user()
    user.otp_expires_at = user.otp_expires_at - timedelta(minutes=11)
    db.session.commit()

    response = client.post("/api/auth/verify-email",
                           json={"email": USER["email"], "code": code})
    assert response.status_code == 400


def test_verify_too_many_attempts(client, mock_send):
    code = register(client, mock_send)
    user = get_user()
    user.otp_attempts = 5
    db.session.commit()

    response = client.post("/api/auth/verify-email",
                           json={"email": USER["email"], "code": code})
    assert response.status_code == 429


def test_verify_unknown_email(client, mock_send):
    response = client.post("/api/auth/verify-email",
                           json={"email": "nobody@example.com", "code": "123456"})
    assert response.status_code == 404


# ---------- Resend code ----------

def test_resend_success(client, mock_send):
    register(client, mock_send)
    user = get_user()
    user.otp_expires_at = user.otp_expires_at - timedelta(minutes=2)
    db.session.commit()

    response = client.post("/api/auth/resend-code", json={"email": USER["email"]})
    assert response.status_code == 200
    assert mock_send.call_count == 2


def test_resend_too_soon(client, mock_send):
    register(client, mock_send)
    response = client.post("/api/auth/resend-code", json={"email": USER["email"]})
    assert response.status_code == 429
    assert mock_send.call_count == 1


def test_resend_already_verified(client, mock_send):
    register_and_verify(client, mock_send)
    response = client.post("/api/auth/resend-code", json={"email": USER["email"]})
    assert response.status_code == 409


def test_resend_unknown_email(client, mock_send):
    response = client.post("/api/auth/resend-code", json={"email": "nobody@example.com"})
    assert response.status_code == 404
    mock_send.assert_not_called()


# ---------- Login ----------

def test_login_wrong_password(client, mock_send):
    register_and_verify(client, mock_send)
    response = client.post("/api/auth/login",
                           json={"email": USER["email"], "password": "WrongPass1"})
    assert response.status_code == 401


def test_login_unknown_email(client, mock_send):
    response = client.post("/api/auth/login",
                           json={"email": "nobody@example.com", "password": "Password123!"})
    assert response.status_code == 401


def test_login_not_verified(client, mock_send):
    register(client, mock_send)
    response = client.post("/api/auth/login",
                           json={"email": USER["email"], "password": USER["password"]})
    assert response.status_code == 403


def test_login_suspended(client, mock_send):
    register_and_verify(client, mock_send)
    user = get_user()
    user.is_suspended = True
    db.session.commit()

    response = client.post("/api/auth/login",
                           json={"email": USER["email"], "password": USER["password"]})
    assert response.status_code == 403


# ---------- /api/users/me ----------

def test_me_without_token(client):
    response = client.get("/api/users/me")
    assert response.status_code == 401
    assert "error" in response.get_json()


def test_me_invalid_token(client):
    response = client.get("/api/users/me",
                          headers={"Authorization": "Bearer not.a.real.token"})
    assert response.status_code == 401
    assert "error" in response.get_json()


def test_me_suspended_after_login(client, mock_send):
    """The token is still valid, but the decorator checks isSuspended every time."""
    register_and_verify(client, mock_send)
    login = client.post("/api/auth/login",
                        json={"email": USER["email"], "password": USER["password"]})
    token = login.get_json()["token"]

    user = get_user()
    user.is_suspended = True
    db.session.commit()

    response = client.get("/api/users/me",
                          headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 403

def _auth_headers(client, mock_send):
    register_and_verify(client, mock_send)
    login_res = client.post("/api/auth/login", json={
        "email": USER["email"],
        "password": USER["password"],
    })
    token = login_res.get_json()["token"]
    return {"Authorization": f"Bearer {token}"}


def test_change_password_without_token(client):
    response = client.post("/api/auth/change-password", json={
        "current_password": USER["password"],
        "new_password": "NewPass456!",
    })
    assert response.status_code == 401


def test_change_password_wrong_current_password(client, mock_send):
    headers = _auth_headers(client, mock_send)
    response = client.post(
        "/api/auth/change-password",
        json={
            "current_password": "WrongPassword1!",
            "new_password": "NewPass456!",
        },
        headers=headers,
    )
    assert response.status_code == 400


@pytest.mark.parametrize("weak_password", [
    "short1A",
    "alllowercase1",
    "ALLUPPERCASE1",
    "NoDigitsHere!",
])
def test_change_password_weak_new_password(client, mock_send, weak_password):
    headers = _auth_headers(client, mock_send)
    response = client.post(
        "/api/auth/change-password",
        json={
            "current_password": USER["password"],
            "new_password": weak_password,
        },
        headers=headers,
    )
    assert response.status_code == 400


def test_change_password_same_as_current(client, mock_send):
    headers = _auth_headers(client, mock_send)
    response = client.post(
        "/api/auth/change-password",
        json={
            "current_password": USER["password"],
            "new_password": USER["password"],
        },
        headers=headers,
    )
    assert response.status_code == 400

def test_reset_password_wrong_code(client, mock_send):
    register_and_verify(client, mock_send)
    client.post("/api/auth/forgot-password", json={"email": USER["email"]})

    response = client.post("/api/auth/reset-password", json={
        "email": USER["email"],
        "code": "000000",
        "new_password": "ResetPass789!",
    })
    assert response.status_code == 400


def test_reset_password_expired_code(client, mock_send, app):
    register_and_verify(client, mock_send)
    client.post("/api/auth/forgot-password", json={"email": USER["email"]})
    reset_code = mock_send.call_args.args[1]

    with app.app_context():
        from datetime import timedelta
        from app.extensions import db
        from app.models.user import User, _now

        user = User.query.filter_by(email=USER["email"]).first()
        user.otp_expires_at = _now() - timedelta(minutes=1)
        db.session.commit()

    response = client.post("/api/auth/reset-password", json={
        "email": USER["email"],
        "code": reset_code,
        "new_password": "ResetPass789!",
    })
    assert response.status_code == 400


@pytest.mark.parametrize("weak_password", [
    "short1A",
    "alllowercase1",
    "ALLUPPERCASE1",
    "NoDigitsHere!",
])
def test_reset_password_weak_password(client, mock_send, weak_password):
    register_and_verify(client, mock_send)
    client.post("/api/auth/forgot-password", json={"email": USER["email"]})
    reset_code = mock_send.call_args.args[1]

    response = client.post("/api/auth/reset-password", json={
        "email": USER["email"],
        "code": reset_code,
        "new_password": weak_password,
    })
    assert response.status_code == 400