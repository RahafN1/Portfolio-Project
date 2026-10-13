from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
app.json.ensure_ascii = False  # عشان العربي يطلع مقروء
CORS(app)  # يسمح لفلاتر على Chrome يتصل

TRAILS = [
    {"id": 1, "name": "مسار حافة العالم", "region": "riyadh", "distance_km": 9,
     "duration": "3-4 ساعات", "difficulty": "medium", "rating": 4.9,
     "is_approved": True, "image_url": None},
    {"id": 2, "name": "مسار وادي حنيفة", "region": "riyadh", "distance_km": 6,
     "duration": "2-3 ساعات", "difficulty": "easy", "rating": 4.6,
     "is_approved": True, "image_url": None},
    {"id": 3, "name": "مسار السودة", "region": "asir", "distance_km": 12,
     "duration": "5-6 ساعات", "difficulty": "hard", "rating": 4.8,
     "is_approved": True, "image_url": None},
]


@app.get("/api/trails")
def get_trails():
    return jsonify(TRAILS)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)