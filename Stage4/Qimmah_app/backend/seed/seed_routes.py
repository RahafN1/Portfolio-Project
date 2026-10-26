"""Load trail routes from seed/routes/<trail_id>.geojson into the trails table.

Fills routeCoordinates, startLatitude/startLongitude and endLatitude/endLongitude.
Run:  docker compose exec api python seed/seed_routes.py
"""
import json
import os
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import create_app  # noqa: E402
from app.extensions import db  # noqa: E402
from app.models import Trail  # noqa: E402

ROUTES_DIR = Path(__file__).parent / "routes"


def find_point(geojson, name):
    """Return (lat, lng) of the named Point feature, or (None, None)."""
    for f in geojson.get("features", []):
        g = f.get("geometry") or {}
        if g.get("type") == "Point" and (f.get("properties") or {}).get("name") == name:
            lng, lat = g["coordinates"][:2]
            return lat, lng
    return None, None


def main():
    app = create_app()
    with app.app_context():
        files = sorted(ROUTES_DIR.glob("*.geojson"))
        if not files:
            print(f"No .geojson files found in {ROUTES_DIR}")
            return
        for path in files:
            if not path.stem.isdigit():
                print(f"SKIP  {path.name}: file name must be the trail id, e.g. 2.geojson")
                continue
            trail = db.session.get(Trail, int(path.stem))
            if trail is None:
                print(f"SKIP  {path.name}: no trail with id {path.stem}")
                continue
            data = json.loads(path.read_text(encoding="utf-8"))
            trail.route_coordinates = data
            trail.start_latitude, trail.start_longitude = find_point(data, "start")
            trail.end_latitude, trail.end_longitude = find_point(data, "end")
            print(f"OK    trail {trail.id}")
        db.session.commit()
        print("Done.")


if __name__ == "__main__":
    main()
