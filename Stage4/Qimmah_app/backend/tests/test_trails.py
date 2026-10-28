"""Tests for endpoints 14 and 15: GET /api/trails and GET /api/trails/{id} (US-03, US-04, US-06, US-07)."""

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



# ---------------- Endpoint 15: GET /api/trails/{id} ----------------

DETAIL_FIELDS = {"id", "name", "description", "region", "difficulty",
                 "distance", "estimated_duration", "images", "start_point",
                 "end_point", "route_coordinates", "safety_tips",
                 "average_rating", "created_at"}


def _first_trail_id(client):
    """The id of the first trail in the list (so we don't guess ids)."""
    return client.get("/api/trails").get_json()["trails"][0]["id"]


def test_trail_details_returns_all_fields(client):
    """US-06 + US-07: one trail returns its full details, start point and route,
    and a guest can open it without a token."""
    trail_id = _first_trail_id(client)
    response = client.get(f"/api/trails/{trail_id}")
    assert response.status_code == 200
    data = response.get_json()
    assert set(data) == DETAIL_FIELDS
    assert data["id"] == trail_id


def test_trail_details_not_found_returns_404(client):
    """A trail id that doesn't exist returns 404 with the unified error shape."""
    response = client.get("/api/trails/99999")
    assert response.status_code == 404
    assert response.get_json()["error"] == "Trail not found"