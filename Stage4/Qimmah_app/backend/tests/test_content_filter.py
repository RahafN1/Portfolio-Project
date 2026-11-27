"""Tests for the content filter and the privacy page."""
import pytest

from app.errors import APIError
from app.services.content_filter import check_clean


@pytest.mark.parametrize("text", ["you IDIOT", "يا غبي", "الحمار", "غبــــي"])
def test_blocks_bad_words(text):
    with pytest.raises(APIError):
        check_clean(text)


@pytest.mark.parametrize("text", [
    "مسار رائع", "كسرنا الرقم",
    "المسار فيه زبالة", "ممنوع اصطحاب كلب", "Great classic trail",
])
def test_allows_normal_text(text):
    assert check_clean(text) == text


def test_privacy_page(client):
    response = client.get("/privacy")
    assert response.status_code == 200
    assert "qimmah.info@gmail.com" in response.get_data(as_text=True)
