from flask import Blueprint, jsonify, request

from app.models.user import User

from app.utils.decorators import token_required

auth_bp = Blueprint("auth", __name__)

def _body():
    """The JSON body, or {} if it is missing or not valid JSON."""
    data = request.get_json(silent=True)
    return data if isinstance(data, dict) else {}


@auth_bp.post("/register")
def register():
    data = _body()
    user = User.register(data.get("name"), data.get("email"), data.get("password"))
    return jsonify({"message": "Verification code sent to your email",
                    "user": user.to_dict()}), 201


@auth_bp.post("/verify-email")
def verify_email():
    data = _body()
    user, token = User.verify_email(data.get("email"), data.get("code"))
    return jsonify({"token": token, "user": user.to_dict()}), 200


@auth_bp.post("/resend-code")
def resend_code():
    data = _body()
    User.resend_code(data.get("email"))
    return jsonify({"message": "A new verification code was sent"}), 200

@auth_bp.post("/login")
def login():
    data = _body()
    user, token = User.login(data.get("email"), data.get("password"))
    return jsonify({
        "token": token,
        "user": user.to_dict()
    }), 200

@auth_bp.get("/me")
@token_required
def get_current_user(current_user):
    return jsonify({
        "user": current_user.to_dict()
    }), 200