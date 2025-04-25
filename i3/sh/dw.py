import requests
import json
import os
import random

# --- Configuration ---
UNSPLASH_ACCESS_KEY = "FFnaFi7NkBHOMsuTNOC2bD6fQoHro0MmmeXBon8B1A0"  # Replace with your actual key
SEARCH_TERMS = ["nature", "abstract", "city", "space", "animals", "landscape", "cars", "car", "racing car"]
ORIENTATION_OPTIONS = ["landscape"]
CONTENT_FILTER = "high"
WALLPAPER_PATH = os.path.expanduser("~/.config/i3/sh/wp/wallpaper.jpg")
ATTRIBUTION_PATH = os.path.expanduser("~/.config/i3/sh/wp/attribution.txt")

def fetch_random_unsplash_image_info():
    """Fetches image URL, download location, and attribution info from Unsplash."""
    url = "https://api.unsplash.com/photos/random"
    headers = {"Authorization": f"Client-ID {UNSPLASH_ACCESS_KEY}"}
    params = {
        "query": random.choice(SEARCH_TERMS),
        "orientation": random.choice(ORIENTATION_OPTIONS),
        "count": 1,
        "content_filter": CONTENT_FILTER
    }

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()[0]  # single image since count=1
        return {
            "image_url": data["urls"]["full"],
            "download_location": data["links"]["download_location"],
            "author_name": data["user"]["name"],
            "author_link": data["links"]["html"]
        }
    except Exception as e:
        print(f"Error fetching Unsplash image: {e}")
        return None

def trigger_download(download_location):
    """Notifies Unsplash of the download (required for API usage)."""
    try:
        headers = {"Authorization": f"Client-ID {UNSPLASH_ACCESS_KEY}"}
        requests.get(download_location, headers=headers)
    except Exception as e:
        print(f"Error triggering download on Unsplash: {e}")

def download_image(image_url, path):
    """Downloads image and saves it to the given path."""
    try:
        response = requests.get(image_url, stream=True)
        response.raise_for_status()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, 'wb') as f:
            for chunk in response.iter_content(8192):
                f.write(chunk)
        print(f"Image downloaded successfully to {path}")
    except Exception as e:
        print(f"Error downloading image: {e}")

def save_attribution(author, link, path):
    """Saves photo attribution to a local file."""
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(f"Photo by {author} on Unsplash: {link}\n")
    print(f"Attribution saved to {path}")

if __name__ == "__main__":
    info = fetch_random_unsplash_image_info()
    if info:
        trigger_download(info["download_location"])
        download_image(info["image_url"], WALLPAPER_PATH)
        save_attribution(info["author_name"], info["author_link"], ATTRIBUTION_PATH)
