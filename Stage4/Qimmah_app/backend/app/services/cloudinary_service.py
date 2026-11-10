import os
import cloudinary
import cloudinary.uploader

cloudinary.config(
    cloud_name=os.getenv("ptn3plua"),
    api_key=os.getenv("726119617784351"),
    api_secret=os.getenv("d6P3r5vlpFHKvJbCmzDTbx1e3So"),
    secure=True
)


def upload_image(file):
    result = cloudinary.uploader.upload(file, folder="qimma/trails")
    return result["secure_url"]
