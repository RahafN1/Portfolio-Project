"""Reject objectionable words in user content (App Store guideline 1.2)."""
import re

from app.errors import APIError

# Whole words only, so normal words that contain these letters are not blocked.
# Add or remove words here.
BANNED_WORDS = (
    "idiot", "stupid", "moron", "dumb", "jerk",
    "حمار", "حمير", "تيس", "غبي", "غبية", "حقير", "تافه", "احمق", "معتوه",
)


def _normalize(text):
    """Lower case, no Arabic diacritics or tatweel, unified letters, no repeats."""
    text = re.sub("[\u064B-\u065F\u0670\u0640]", "", text.lower())
    text = text.translate(str.maketrans("أإآىة", "ااايه"))
    return re.sub(r"(.)\1{2,}", r"\1", text)


_BANNED = {_normalize(word) for word in BANNED_WORDS}


def check_clean(text):
    """Raise APIError(400) if the text has a banned word."""
    for word in re.findall(r"\w+", _normalize(text)):
        # also check the word without "ال" or "يا" in front of it
        forms = {word, re.sub("^(ال|يا)", "", word)}
        if forms & _BANNED:
            raise APIError("Your text contains inappropriate language", 400)
    return text
