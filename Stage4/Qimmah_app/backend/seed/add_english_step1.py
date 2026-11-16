from app.extensions import db
from app.models.trail import Trail

# نصائح السلامة: نفسها لكل المسارات
safety_tips_en = """• Wear shoes suitable for hiking.
• Carry enough water.
• Avoid the trails in bad weather.
• Follow the signs and don't leave trash behind.
• Respect the environment and plants, and don't pick or disturb wildlife.
• Use sun protection (hat, sunscreen)."""

# المنطقة: اسم المنطقة وأرقام المسارات اللي فيها
regions = {
    "Al Ghat": [1, 4],
    "Hawtat Sudair": [2],
    "Ad Dawadmi": [3, 7],
    "Al Quwayiyah": [5, 6, 8],
    "Hail": [9, 11, 12],
    "Taif": [10, 13],
}

# المدة: النص الإنجليزي وأرقام المسارات اللي لها نفس المدة
durations = {
    "1.5 hours": [1, 11],
    "2 hours": [2, 13],
    "2.5 hours": [4],
    "3 hours": [3, 6, 7, 8],
    "4 hours": [5, 10, 12],
    "6 hours": [9],
}

for trail in Trail.query.all():
    trail.safety_tips_en = safety_tips_en

for region, ids in regions.items():
    for trail_id in ids:
        db.session.get(Trail, trail_id).region_en = region

for duration, ids in durations.items():
    for trail_id in ids:
        db.session.get(Trail, trail_id).estimated_duration_en = duration

db.session.commit()
print("Done: safety tips, regions and durations updated")
