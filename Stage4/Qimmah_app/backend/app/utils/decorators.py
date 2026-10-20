from functools import wraps

from flask_jwt_extended import get_jwt_identity, verify_jwt_in_request

from app.errors import APIError
from app.extensions import db
from app.models.user import User


def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        verify_jwt_in_request()
        user_id = get_jwt_identity()

        user = db.session.get(User, int(user_id))
        if not user:
            raise APIError("User not found", 401)

        if user.is_suspended:
            raise APIError("Account suspended", 403)

        return f(current_user=user, *args, **kwargs)
    return decorated