import os
from datetime import timedelta

from dotenv import load_dotenv

load_dotenv()  # read the values from the .env file


class Config:
    """App settings, read from environment variables (.env)."""
    SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {"pool_pre_ping": True, "pool_recycle": 280}
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET", "change-me")
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=24)  # Stage 3: tokens expire after 24h
    JSON_AS_ASCII = False  # return Arabic text as-is
    JSON_SORT_KEYS = False

    RESEND_API_KEY = os.environ.get("RESEND_API_KEY", "")
    MAIL_FROM = os.environ.get("MAIL_FROM", "Qimma <onboarding@resend.dev>")


class TestConfig(Config):
    """Used by pytest: a throwaway in-memory database."""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    JWT_SECRET_KEY = "test-secret-key-that-is-long-enough-32"
    RESEND_API_KEY = "re_test"
