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
            "/api/users/me",
            headers={"Authorization": f"Bearer {token}"},
        )

        assert response.status_code == 200
        data = response.get_json()
        assert data["user"]["email"] == USER["email"]

def test_change_password_success(client):
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

        new_password = "NewPass456!"
        change_res = client.post(
            "/api/auth/change-password",
            json={
                "current_password": USER["password"],
                "new_password": new_password,
            },
            headers={"Authorization": f"Bearer {token}"},
        )
        assert change_res.status_code == 200

        old_login = client.post("/api/auth/login", json={
            "email": USER["email"],
            "password": USER["password"],
        })
        assert old_login.status_code == 401

        new_login = client.post("/api/auth/login", json={
            "email": USER["email"],
            "password": new_password,
        })
        assert new_login.status_code == 200
        assert "token" in new_login.get_json()

def test_forgot_and_reset_password_success(client):
    with patch("app.models.user.send_otp_email") as mock_send:
        client.post("/api/auth/register", json=USER)
        reg_code = mock_send.call_args.args[1]

        verify_res = client.post("/api/auth/verify-email", json={
            "email": USER["email"],
            "code": reg_code,
        })
        assert verify_res.status_code == 200

        forgot_res = client.post("/api/auth/forgot-password", json={
            "email": USER["email"],
        })
        assert forgot_res.status_code == 200
        reset_code = mock_send.call_args.args[1]

        new_password = "ResetPass789!"
        reset_res = client.post("/api/auth/reset-password", json={
            "email": USER["email"],
            "code": reset_code,
            "new_password": new_password,
        })
        assert reset_res.status_code == 200

        old_login = client.post("/api/auth/login", json={
            "email": USER["email"],
            "password": USER["password"],
        })
        assert old_login.status_code == 401

        new_login = client.post("/api/auth/login", json={
            "email": USER["email"],
            "password": new_password,
        })
        assert new_login.status_code == 200
        assert "token" in new_login.get_json()