import os
from datetime import timedelta


class Config:
    """App settings, read from environment variables (.env)."""
    SQLALCHEMY_DATABASE_URI = os.environ.get("DATABASE_URL")
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET", "change-me")
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(hours=24)  # Stage 3: tokens expire after 24h
    JSON_AS_ASCII = False  # return Arabic text as-is
    JSON_SORT_KEYS = False


class TestConfig(Config):
    """Used by pytest: a throwaway in-memory database."""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = "sqlite:///:memory:"
    JWT_SECRET_KEY = "test-secret"
