import requests
import json
import os
import random

# --- Configuration ---
UNSPLASH_ACCESS_KEY = "FFnaFi7NkBHOMsuTNOC2bD6fQoHro0MmmeXBon8B1A0"  # Replace with your Unsplash Access Key
SEARCH_TERMS = ["nature", "abstract", "city", "space", "animals", "landscape","cars","car","racing car"]
ORIENTATION_OPTIONS = ["landscape"]  # You can add "portrait" if you like
CONTENT_FILTER = "high"  # Or "low"
DOWNLOAD_PATH = os.path.expanduser("~/.config/i3/sh/wallpaper.jpg")

def fetch_random_unsplash_image_url():
    """Fetches a random image URL from Unsplash based on search terms."""
    base_url = "https://api.unsplash.com/photos/random"
    headers = {
        "Authorization": f"Client-ID {UNSPLASH_ACCESS_KEY}"
    }
    params = {
        "query": random.choice(SEARCH_TERMS),
        "orientation": random.choice(ORIENTATION_OPTIONS),
        "count": 1,
        "content_filter": CONTENT_FILTER
    }

    try:
        response = requests.get(base_url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()

        if data and isinstance(data, list) and data[0].get('urls') and data[0]['urls'].get('full'):
            return data[0]['urls']['full']  # Or 'raw', 'regular', 'small', 'thumb'
        else:
            print("Could not retrieve image URL from Unsplash response.")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching image URL from Unsplash: {e}")
        return None
    except json.JSONDecodeError:
        print("Error decoding JSON response from Unsplash.")
        return None

def download_image(image_url, save_path):
    """Downloads an image from the given URL and saves it to the specified path."""
    if not image_url:
        return False

    try:
        response = requests.get(image_url, stream=True)
        response.raise_for_status()
        os.makedirs(os.path.dirname(save_path), exist_ok=True)
        with open(save_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)
        print(f"Image downloaded successfully from Unsplash to {save_path}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"Error downloading image: {e}")
        return False

if __name__ == "__main__":
    image_url = fetch_random_unsplash_image_url()
    if image_url:
        download_image(image_url, DOWNLOAD_PATH)
