from app.extensions import db
from app.models.trail import Trail

TEST_NAME = "TEST - مسار تجريبي"

# نتأكد أنه ما انضاف قبل، عشان ما يتكرر لو شغّلتي الملف مرتين
if Trail.query.filter_by(name=TEST_NAME).first():
    print("The test trail already exists, nothing added")
else:
    # النقاط من البداية إلى النهاية بصيغة [الطول, العرض]
    points = [
        [46.7131477, 24.8536744],  # البداية
        [46.7131688, 24.8536503],
        [46.7131303, 24.8536233],
        [46.7130625, 24.8536135],
        [46.7129737, 24.8536102],
        [46.7128956, 24.8536144],
        [46.7128194, 24.8536120],
        [46.7127189, 24.8536336],
        [46.7126491, 24.8535825],
        [46.7126257, 24.8535950],
        [46.7126008, 24.8536220],  # النهاية
    ]

    # نفس شكل route_coordinates في المسارات الثانية
    route = {
        "type": "FeatureCollection",
        "features": [
            {"type": "Feature", "properties": {"name": "route"},
             "geometry": {"type": "LineString", "coordinates": points}},
            {"type": "Feature", "properties": {"name": "start"},
             "geometry": {"type": "Point", "coordinates": points[0]}},
            {"type": "Feature", "properties": {"name": "end"},
             "geometry": {"type": "Point", "coordinates": points[-1]}},
        ],
    }

    trail = Trail(
        name=TEST_NAME,
        name_en="TEST - Test trail",
        description="مسار تجريبي عند الأكاديمية لتجربة الموقع والخريطة.",
        description_en="A test trail at the academy to try the location and the map.",
        region="الرياض",
        region_en="Riyadh",
        difficulty="easy",
        distance=0.07,
        estimated_duration="5 دقائق",
        estimated_duration_en="5 minutes",
        images="[]",
        start_latitude=24.8536744,
        start_longitude=46.7131477,
        end_latitude=24.8536220,
        end_longitude=46.7126008,
        route_coordinates=route,
    )
    db.session.add(trail)
    db.session.commit()
    print("Done: test trail added with id", trail.id)
