import requests
import json
import os
import random

# --- Configuration ---
API_KEY = "37076604-b62b9903a565ff2265923b75f"  # Replace with your actual Pixabay API key
SEARCH_TERMS = [
   "model"
]
IMAGE_TYPE = "photo"
ORIENTATION_OPTIONS = ["landscape"] # You can add "portrait" if you like
SAFESEARCH = "false"
PER_PAGE = 10
DOWNLOAD_PATH = os.path.expanduser("~/.config/i3/sh/wallpaper.jpg")

def fetch_random_image_url():
    """Fetches a random image URL from Pixabay, with more randomness."""
    base_url = "https://pixabay.com/api/"
    params = {
        "key": API_KEY,
        "q": random.choice(SEARCH_TERMS),
        "image_type": IMAGE_TYPE,
        "orientation": "landscape",
        "safesearch": SAFESEARCH,
        "per_page": PER_PAGE
    }

    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        data = response.json()

        if data['hits']:
            random_hit = random.choice(data['hits'])
            return random_hit['fullHDURL'] if 'fullHDURL' in random_hit and random_hit['fullHDURL'] else random_hit['largeImageURL']
        else:
            print("No images found for the given search terms.")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching image URL: {e}")
        return None
    except json.JSONDecodeError:
        print("Error decoding JSON response.")
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
        print(f"Image downloaded successfully to {save_path}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"Error downloading image: {e}")
        return False

if __name__ == "__main__":
    image_url = fetch_random_image_url()
    if image_url:
        download_image(image_url, DOWNLOAD_PATH)

