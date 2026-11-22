from flask import Blueprint, jsonify, request
from flask_jwt_extended import get_jwt, get_jwt_identity, jwt_required

from app.errors import APIError
from app.extensions import db
from app.models.token_blocklist import TokenBlocklist
from app.models.user import User

auth_bp = Blueprint("auth", __name__)


def _body():
    """The JSON body, or {} if it is missing or not valid JSON."""
    data = request.get_json(silent=True)
    return data if isinstance(data, dict) else {}


@auth_bp.post("/register")
def register():
    """
    Endpoint 1 — create a new account and send a verification code
    ---
    tags:
      - Auth
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - name
            - email
            - password
          properties:
            name:
              type: string
              example: Sara
            email:
              type: string
              example: sara@example.com
            password:
              type: string
              example: Pass1234
    responses:
      201:
        description: Account created, verification code sent
      400:
        description: Missing or invalid data
      409:
        description: Email already registered
    """
    data = _body()
    user = User.register(data.get("name"), data.get("email"), data.get("password"))
    return jsonify({"message": "Verification code sent to your email",
                    "user": user.to_dict()}), 201


@auth_bp.post("/verify-email")
def verify_email():
    """
    Endpoint 2 — verify the email with the code and get a token
    ---
    tags:
      - Auth
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - email
            - code
          properties:
            email:
              type: string
              example: sara@example.com
            code:
              type: string
              example: "123456"
    responses:
      200:
        description: Email verified, token returned
      400:
        description: Wrong or expired code
      404:
        description: Account not found
    """
    data = _body()
    user, token = User.verify_email(data.get("email"), data.get("code"))
    return jsonify({"token": token, "user": user.to_dict()}), 200


@auth_bp.post("/resend-code")
def resend_code():
    """
    Endpoint 3 — send a new verification code
    ---
    tags:
      - Auth
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - email
          properties:
            email:
              type: string
              example: sara@example.com
    responses:
      200:
        description: A new verification code was sent
      400:
        description: Missing or invalid email
      404:
        description: Account not found
    """
    data = _body()
    User.resend_code(data.get("email"))
    return jsonify({"message": "A new verification code was sent"}), 200


@auth_bp.post("/login")
def login():
    """
    Endpoint 4 — log in and get a token
    ---
    tags:
      - Auth
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - email
            - password
          properties:
            email:
              type: string
              example: sara@example.com
            password:
              type: string
              example: Pass1234
    responses:
      200:
        description: Logged in, token returned
      401:
        description: Wrong email or password
      403:
        description: Email not verified or account suspended
    """
    data = _body()
    user, token = User.login(data.get("email"), data.get("password"))
    return jsonify({"token": token, "user": user.to_dict()}), 200


@auth_bp.post("/logout")
@jwt_required()
def logout():
    """
    Log out the current user
    ---
    tags:
      - Auth
    security:
      - Bearer: []
    responses:
      200:
        description: Logged out successfully
      401:
        description: Missing, invalid or revoked token
    """
    jti = get_jwt()["jti"]
    db.session.add(TokenBlocklist(jti=jti))
    db.session.commit()
    return jsonify({"message": "Logged out successfully"}), 200


@auth_bp.post("/change-password")
@jwt_required()
def change_password():
    """
    Change the password of the logged-in user
    ---
    tags:
      - Auth
    security:
      - Bearer: []
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - current_password
            - new_password
          properties:
            current_password:
              type: string
              example: Pass1234
            new_password:
              type: string
              example: NewPass5678
    responses:
      200:
        description: Password changed successfully
      400:
        description: Missing or invalid data, or wrong current password
      401:
        description: Missing, invalid or revoked token
      403:
        description: Account suspended
      404:
        description: Account not found
    """
    data = _body()
    user_id = get_jwt_identity()
    user = db.session.get(User, int(user_id))
    if user is None:
        raise APIError("Account not found", 404)
    if user.is_suspended:
        raise APIError("Account suspended", 403)

    user.change_password(data.get("current_password"), data.get("new_password"))
    return jsonify({"message": "Password changed successfully"}), 200

@auth_bp.post("/forgot-password")
def forgot_password():
    """
    Request a verification code to reset a forgotten password
    ---
    tags:
      - Auth
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - email
          properties:
            email:
              type: string
              example: sara@example.com
    responses:
      200:
        description: If the email is registered, a verification code was sent
      400:
        description: Missing or invalid email
    """
    data = _body()
    User.request_password_reset(data.get("email"))
    return jsonify({"message": "If that email is registered, a verification code was sent"}), 200


@auth_bp.post("/reset-password")
def reset_password():
    """
    Reset the password using the verification code
    ---
    tags:
      - Auth
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - email
            - code
            - new_password
          properties:
            email:
              type: string
              example: sara@example.com
            code:
              type: string
              example: "123456"
            new_password:
              type: string
              example: NewPass5678
    responses:
      200:
        description: Password reset successfully
      400:
        description: Missing or invalid data, or wrong or expired code
      404:
        description: Account not found
    """
    data = _body()
    User.reset_password(
        data.get("email"),
        data.get("code"),
        data.get("new_password"),
    )
    return jsonify({"message": "Password reset successfully"}), 200
