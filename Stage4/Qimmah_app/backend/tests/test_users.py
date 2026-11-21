from unittest.mock import patch

USER = {
    "name": "Zahra",
    "email": "zahra@example.com",
    "password": "Password123!",
}


def _login_token(client):
    """Register, verify and log in a user, then return the JWT."""
    with patch("app.models.user.send_otp_email") as mock_send:
        client.post("/api/auth/register", json=USER)
        code = mock_send.call_args.args[1]

    client.post("/api/auth/verify-email", json={
        "email": USER["email"],
        "code": code,
    })
    login_res = client.post("/api/auth/login", json={
        "email": USER["email"],
        "password": USER["password"],
    })
    assert login_res.status_code == 200
    return login_res.get_json()["token"]


def test_update_profile_requires_token(client):
    response = client.put("/api/users/me", json={"name": "New Name"})
    assert response.status_code == 401


def test_update_profile_name(client):
    token = _login_token(client)
    headers = {"Authorization": f"Bearer {token}"}

    response = client.put("/api/users/me", json={"name": "Sarah"},
                          headers=headers)
    assert response.status_code == 200

    me = client.get("/api/users/me", headers=headers).get_json()
    assert me["user"]["name"] == "Sarah"


def test_update_profile_email_not_changed(client):
    token = _login_token(client)
    headers = {"Authorization": f"Bearer {token}"}

    client.put("/api/users/me",
               json={"name": "Sarah", "email": "other@example.com"},
               headers=headers)

    me = client.get("/api/users/me", headers=headers).get_json()
    assert me["user"]["email"] == USER["email"]
