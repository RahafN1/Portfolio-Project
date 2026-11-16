from app.extensions import db
from app.models.trail import Trail

# رقم المسار: (الاسم, الوصف)
trails_en = {
    1: ("Al Ghat Historical Trail",
        "Al Ghat Historical Trail is located in Al Ghat, Riyadh Region. It is an easy trail 2.83 km long, with a total ascent of about 93 m, and takes about an hour and a half to complete."),
    2: ("Hawtat Sudair Trail",
        "Hawtat Sudair Trail is located in Hawtat Sudair, Riyadh Region. It is an easy trail 5.55 km long, with a total ascent of about 125 m, and takes about 2 hours to complete."),
    3: ("Mount Thahlan Trail",
        "Mount Thahlan Trail is located in Ad Dawadmi, Riyadh Region. It is a moderate trail 5.47 km long, with a total ascent of about 566 m, and takes about 3 hours to complete."),
    4: ("Al Ghat Historical Trails - Al Hawtah Trail",
        "Al Hawtah Trail, one of the Al Ghat historical trails, is located in Al Ghat, Riyadh Region. It is a moderate trail 7.46 km long, with a total ascent of about 91 m, and takes about two and a half hours to complete."),
    5: ("Musaigrah Trail",
        "Musaigrah Trail is located in Al Quwayiyah, Riyadh Region. It is an easy trail 8.33 km long, with a total ascent of about 144 m, and takes about 4 hours to complete."),
    6: ("Mizil Jabal Al-Shaqraa Trail",
        "Mizil Jabal Al-Shaqraa Trail is located in Al Quwayiyah, Riyadh Region. It is an easy trail 5.45 km long, with a total ascent of about 141 m, and takes about 3 hours to complete."),
    7: ("Zabnah Trail",
        "Zabnah Trail is located in Ad Dawadmi, Riyadh Region. It is a moderate trail 8 km long, with a total ascent of about 288 m, and takes about 3 hours to complete."),
    8: ("Al Quwayiyah Trail",
        "Al Quwayiyah Trail is located in Al Quwayiyah, Riyadh Region. It is an easy trail 6.13 km long, with a total ascent of about 228 m, and takes about 3 hours to complete."),
    9: ("Qarh - Al Mardiyah Trail",
        "Qarh - Al Mardiyah Trail is located in Hail Region. It is a hard trail 7.59 km long, with a total ascent of about 661 m, and takes about 6 hours to complete."),
    10: ("Kara Archaeological Trail",
         "Kara Archaeological Trail is located in Taif, Makkah Region. It is a moderate trail 5.84 km long, with a total ascent of about 515 m, and takes about 4 hours to complete."),
    11: ("Hatem Fire Lighthouse Trail",
         "Hatem Fire Lighthouse Trail is located in Hail Region. It is a moderate trail 4.34 km long, with a total ascent of about 182 m, and takes about an hour and a half to complete."),
    12: ("Egdah - Lamah Trail",
         "Egdah - Lamah Trail is located in Hail Region. It is a moderate trail 11.8 km long, with a total ascent of about 279 m, and takes about 4 hours to complete."),
    13: ("Al Makhadah Trail",
         "Al Makhadah Trail is located in Taif, Makkah Region. It is an easy trail 5.11 km long, with a total ascent of about 94 m, and takes about 2 hours to complete."),
}

for trail_id, (name, description) in trails_en.items():
    trail = db.session.get(Trail, trail_id)
    trail.name_en = name
    trail.description_en = description

db.session.commit()
print("Done: english names and descriptions updated")
