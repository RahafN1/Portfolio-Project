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
    Register a new account and send a verification code to the email
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
              example: MyPassword123
    responses:
      201:
        description: Account created and a verification code was sent to the email
      400:
        description: Missing or invalid data
    """
    data = _body()
    user = User.register(data.get("name"), data.get("email"), data.get("password"))
    return jsonify({"message": "Verification code sent to your email",
                    "user": user.to_dict()}), 201


@auth_bp.post("/verify-email")
def verify_email():
    """
    Verify the email with the code and return a token
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
        description: Email verified, returns the token and the user
      400:
        description: Missing data or wrong code
    """
    data = _body()
    user, token = User.verify_email(data.get("email"), data.get("code"))
    return jsonify({"token": token, "user": user.to_dict()}), 200


@auth_bp.post("/resend-code")
def resend_code():
    """
    Send a new verification code to the email
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
    """
    data = _body()
    User.resend_code(data.get("email"))
    return jsonify({"message": "A new verification code was sent"}), 200


@auth_bp.post("/login")
def login():
    """
    Log in and return a token
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
              example: MyPassword123
    responses:
      200:
        description: Logged in, returns the token and the user
      400:
        description: Missing data or wrong email or password
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
    Change the password of the current user
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
              example: MyPassword123
            new_password:
              type: string
              example: MyNewPassword456
    responses:
      200:
        description: Password changed successfully
      400:
        description: Missing data or wrong current password
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
