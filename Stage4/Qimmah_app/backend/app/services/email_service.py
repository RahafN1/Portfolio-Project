import resend
from flask import current_app

from app.errors import APIError


def send_otp_email(email, code):
    """Send the 6-digit verification code with Resend.

    Without RESEND_API_KEY (local development) the code is printed
    in the API logs instead, so you can test without sending emails.
    """
    api_key = current_app.config.get("RESEND_API_KEY")
    if not api_key:
        print(f"[DEV] OTP for {email}: {code}", flush=True)
        return

    resend.api_key = api_key
    try:
        resend.Emails.send({
            "from": current_app.config["MAIL_FROM"],
            "to": [email],
            "subject": "رمز التحقق - قمة",
            "html": f"<p>رمز التحقق الخاص بك: <b>{code}</b></p><p>صالح لمدة 10 دقائق.</p>",
        })
    except Exception:
        current_app.logger.exception("Resend failed")
        raise APIError("Could not send the verification code, please request a new one", 502)