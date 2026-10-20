from unittest.mock import patch

USER = {
    "name": "Zahra",
    "email": "zahra@example.com",
    "password": "Password123!",
}


def test_register_success(client):
    with patch("app.models.user.send_otp_email") as mock_send:
        response = client.post("/api/auth/register", json=USER)

        assert response.status_code == 201
        data = response.get_json()
        assert "user" in data
        mock_send.assert_called_once()


def test_login_success(client):
    with patch("app.models.user.send_otp_email") as mock_send:
        client.post("/api/auth/register", json=USER)
        code = mock_send.call_args.args[1]

        verify_res = client.post("/api/auth/verify-email", json={
            "email": USER["email"],
            "code": code,
        })
        assert verify_res.status_code == 200

        response = client.post("/api/auth/login", json={
            "email": USER["email"],
            "password": USER["password"],
        })

        assert response.status_code == 200
        data = response.get_json()
        assert "token" in data


def test_get_me_protected(client):
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
        token = login_res.get_json()["token"]

        response = client.get(
            "/api/auth/me",
            headers={"Authorization": f"Bearer {token}"},
        )

        assert response.status_code == 200
        data = response.get_json()
        assert data["user"]["email"] == USER["email"]