"""Auth module — Stage 3 endpoints 1-4 (to be built: T07, T08).

1. POST /api/auth/register        🌐
2. POST /api/auth/verify-email    🌐
3. POST /api/auth/resend-code     🌐
4. POST /api/auth/login           🌐
"""
from flask import Blueprint

auth_bp = Blueprint("auth", __name__)
