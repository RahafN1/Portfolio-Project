import re
import secrets
from datetime import datetime, timedelta, timezone

from flask_jwt_extended import create_access_token
from werkzeug.security import check_password_hash, generate_password_hash

from app.errors import APIError
from app.extensions import db
from app.services.email_service import send_otp_email

EMAIL_PATTERN = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
MIN_PASSWORD_LENGTH = 8
OTP_LIFETIME = timedelta(minutes=10)
OTP_MAX_ATTEMPTS = 5
RESEND_WAIT = timedelta(minutes=1)


def _now():
    """Current UTC time without timezone info (MySQL DATETIME has none)."""
    return datetime.now(timezone.utc).replace(tzinfo=None)


def _text(value):
    """Return the value if it is a string, otherwise an empty string."""
    return value if isinstance(value, str) else ""


class User(db.Model):
    """A registered user (UML: User). Admin inherits from it."""
    __tablename__ = "users"

    # ---------- Attributes ----------
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    role = db.Column(db.Enum("user", "admin"), nullable=False, default="user")
    is_verified = db.Column("isVerified", db.Boolean, nullable=False, default=False)
    otp_code_hash = db.Column("otpCodeHash", db.String(255))
    otp_expires_at = db.Column("otpExpiresAt", db.DateTime)
    otp_attempts = db.Column("otpAttempts", db.Integer, nullable=False, default=0)
    is_suspended = db.Column("isSuspended", db.Boolean, nullable=False, default=False)

    # UML: Admin inherits from User (the role column says which one)
    __mapper_args__ = {"polymorphic_on": role, "polymorphic_identity": "user"}

    # ---------- Relationships (enable when the classes exist) ----------
    # reviews = db.relationship("Review", backref="user",
    #                           cascade="all, delete-orphan", passive_deletes=True)
    # favorites = db.relationship("Favorite", backref="user",
    #                             cascade="all, delete-orphan", passive_deletes=True)
    # completed_trails = db.relationship("CompletedTrail", backref="user",
    #                                    cascade="all, delete-orphan", passive_deletes=True)

    # ---------- Helpers ----------
    def to_dict(self):
        """The user object returned by the API (password and OTP never included)."""
        return {"id": self.id, "name": self.name, "email": self.email, "role": self.role}

    def create_token(self):
        """JWT valid for 24 hours (set in config.py), with the role inside."""
        return create_access_token(identity=str(self.id),
                                   additional_claims={"role": self.role})

    def _new_otp(self):
        """Create a new 6-digit code, store only its hash, return the plain code."""
        code = f"{secrets.randbelow(1_000_000):06d}"
        self.otp_code_hash = generate_password_hash(code)
        self.otp_expires_at = _now() + OTP_LIFETIME
        self.otp_attempts = 0
        return code

    @staticmethod
    def _clean_email(email):
        return _text(email).strip().lower()

    @classmethod
    def _get_by_email(cls, email):
        user = User.query.filter_by(email=cls._clean_email(email)).first()
        if user is None:
            raise APIError("Account not found", 404)
        return user

    # ---------- Methods (UML) ----------
    @classmethod
    def register(cls, name, email, password):
        """UML: register() — create an unverified account and send a code."""
        name = _text(name).strip()
        email = cls._clean_email(email)
        password = _text(password)
        if not name:
            raise APIError("Name is required", 400)
        if not EMAIL_PATTERN.match(email):
            raise APIError("Invalid email", 400)
        if len(password) < MIN_PASSWORD_LENGTH:
            raise APIError(f"Password must be at least {MIN_PASSWORD_LENGTH} characters", 400)

        user = User.query.filter_by(email=email).first()
        if user and user.is_verified:
            raise APIError("Email already registered", 409)
        if user is None:
            user = User(email=email)
            db.session.add(user)
        user.name = name
        user.password = generate_password_hash(password)

        code = user._new_otp()
        db.session.commit()
        send_otp_email(user.email, code)
        return user

    @classmethod
    def verify_email(cls, email, code):
        """UML: verifyEmail() — check the code; on success return (user, token)."""
        user = cls._get_by_email(email)
        if user.is_verified:
            raise APIError("Email already verified", 400)
        if user.otp_attempts >= OTP_MAX_ATTEMPTS:
            raise APIError("Too many wrong attempts, request a new code", 429)
        if not user.otp_code_hash or _now() > user.otp_expires_at:
            raise APIError("Code expired, request a new code", 400)
        if not check_password_hash(user.otp_code_hash, _text(code).strip()):
            user.otp_attempts += 1
            db.session.commit()
            raise APIError("Wrong verification code", 400)

        user.is_verified = True
        user.otp_code_hash = None
        user.otp_expires_at = None
        user.otp_attempts = 0
        db.session.commit()
        return user, user.create_token()

    @classmethod
    def resend_code(cls, email):
        """UML: resendCode() — new code, at most once per minute."""
        user = cls._get_by_email(email)
        if user.is_verified:
            raise APIError("Email already verified", 409)
        if user.otp_expires_at:
            sent_at = user.otp_expires_at - OTP_LIFETIME
            if _now() < sent_at + RESEND_WAIT:
                raise APIError("Please wait a minute before requesting a new code", 429)
        code = user._new_otp()
        db.session.commit()
        send_otp_email(user.email, code)

    @classmethod
    def login(cls, email, password):
        """UML: login() — on success return (user, token)."""
        user = User.query.filter_by(email=cls._clean_email(email)).first()
        if user is None or not check_password_hash(user.password, _text(password)):
            raise APIError("Invalid email or password", 401)
        if not user.is_verified:
            raise APIError("Email not verified", 403)
        if user.is_suspended:
            raise APIError("Account suspended", 403)
        return user, user.create_token()

    def logout(self):
        """UML: logout() — done in the app: it deletes the JWT from the device.
        The server keeps no session, so there is nothing to do here."""
        return None
    
    def update_name(self, name):
        """Edit profile — change the user's name (email can't be changed)."""
        name = _text(name).strip()
        if not name:
            raise APIError("Name is required", 400)

        self.name = name
        db.session.commit()
        return self
    
    # These work once Review, Favorite and CompletedTrail are built.
    def view_favorites(self):
        """UML: viewFavorites()."""
        from app.models import Favorite
        return Favorite.get_user_favorites(self.id)

    def add_favorite(self, trail_id):
        """UML: addFavorite(trailId)."""
        from app.models import Favorite
        return Favorite.add_favorite(self.id, trail_id)

    def remove_favorite(self, trail_id):
        """UML: removeFavorite(trailId)."""
        from app.models import Favorite
        Favorite.remove_favorite(self.id, trail_id)

    def view_my_reviews(self):
        """UML: viewMyReviews() — newest first."""
        from app.models import Review
        return (Review.query.filter_by(user_id=self.id)
                .order_by(Review.created_at.desc()).all())

    def mark_trail_as_completed(self, trail_id):
        """UML: markTrailAsCompleted(trailId)."""
        from app.models import CompletedTrail
        return CompletedTrail.mark_as_completed(self.id, trail_id)

    def view_completed_trails(self):
        """UML: viewCompletedTrails()."""
        from app.models import CompletedTrail
        return CompletedTrail.get_completed_trails(self.id)
