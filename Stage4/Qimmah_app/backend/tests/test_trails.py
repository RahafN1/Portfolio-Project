"""Tests for endpoint 14: GET /api/trails (US-03, US-04)."""

SUMMARY_FIELDS = {"id", "name", "region", "difficulty", "distance",
                  "estimated_duration", "average_rating", "cover_image",
                  "start_point"}


def test_list_returns_trail_summaries(client):
    """US-04: the list returns every trail with the summary fields only."""
    data = client.get("/api/trails").get_json()
    assert data["total"] == 2 and data["page"] == 1
    trail = data["trails"][0]
    assert set(trail) == SUMMARY_FIELDS
    assert trail["average_rating"] is None
    assert trail["cover_image"] == "https://example.com/a.jpg"


def test_guest_can_browse_without_token(client):
    """US-03: a request without a token is allowed."""
    response = client.get("/api/trails")
    assert response.status_code == 200


def test_filter_by_difficulty(client):
    data = client.get("/api/trails?difficulty=hard").get_json()
    assert data["total"] == 1
    assert data["trails"][0]["name"] == "مسار صعب"


def test_invalid_difficulty_returns_400(client):
    response = client.get("/api/trails?difficulty=xyz")
    assert response.status_code == 400
    assert "error" in response.get_json()
