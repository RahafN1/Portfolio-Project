"""Clean a GeoJSON exported from a GPX file (Wikiloc, geojson.io, ...).

Keeps only the trail line (2D [lng, lat]), drops times / elevation / waypoints,
adds "start" and "end" points, and saves it as seed/routes/<trail_id>.geojson.

Run:  docker compose exec api python seed/clean_route.py seed/raw/<file>.geojson <trail_id>
"""
import json
import math
import sys
from pathlib import Path

ROUTES_DIR = Path(__file__).parent / "routes"


def line_coords(geojson):
    """Collect all line points from LineString / MultiLineString features."""
    coords = []
    for f in geojson.get("features", []):
        g = f.get("geometry") or {}
        if g.get("type") == "LineString":
            coords += g["coordinates"]
        elif g.get("type") == "MultiLineString":
            for part in g["coordinates"]:
                coords += part
    return [[round(c[0], 6), round(c[1], 6)] for c in coords]


def length_km(coords):
    """Approximate route length (haversine)."""
    total = 0.0
    for (lng1, lat1), (lng2, lat2) in zip(coords, coords[1:]):
        p1, p2 = math.radians(lat1), math.radians(lat2)
        dp, dl = p2 - p1, math.radians(lng2 - lng1)
        a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
        total += 6371 * 2 * math.asin(math.sqrt(a))
    return total


def point(name, coord):
    return {"type": "Feature", "properties": {"name": name},
            "geometry": {"type": "Point", "coordinates": coord}}


def main():
    if len(sys.argv) != 3 or not sys.argv[2].isdigit():
        print("Usage: python seed/clean_route.py <input.geojson> <trail_id>")
        sys.exit(1)
    src, trail_id = Path(sys.argv[1]), int(sys.argv[2])
    coords = line_coords(json.loads(src.read_text(encoding="utf-8")))
    if len(coords) < 2:
        print("No trail line found in this file.")
        sys.exit(1)

    cleaned = {
        "type": "FeatureCollection",
        "features": [
            {"type": "Feature", "properties": {"name": "route"},
             "geometry": {"type": "LineString", "coordinates": coords}},
            point("start", coords[0]),
            point("end", coords[-1]),
        ],
    }
    ROUTES_DIR.mkdir(exist_ok=True)
    out = ROUTES_DIR / f"{trail_id}.geojson"
    out.write_text(json.dumps(cleaned, separators=(",", ":")), encoding="utf-8")
    print(f"Saved {out}")
    print(f"Points: {len(coords)} | Length: {length_km(coords):.2f} km | "
          f"Start: {coords[0][1]}, {coords[0][0]} | End: {coords[-1][1]}, {coords[-1][0]}")


if __name__ == "__main__":
    main()
