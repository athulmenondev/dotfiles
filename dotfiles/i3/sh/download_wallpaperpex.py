import requests
import json
import os
import random

# --- Configuration ---
PEXELS_API_KEY = "add your pexels api"  # Replace with your Pexels API Key
SEARCH_TERMS = ["nature", "abstract", "city", "space", "animals", "landscape"]
ORIENTATION_OPTIONS = ["landscape"]  # You can add "portrait" if you like
SIZE = "large"  # Or "medium", "small"
PER_PAGE = 20  # Fetch a few images and pick one
DOWNLOAD_PATH = os.path.expanduser("~/.config/i3/sh/wallpaper.jpg")

def fetch_random_pexels_image_url():
    """Fetches a random image URL from Pexels based on search terms."""
    base_url = "https://api.pexels.com/v1/search"
    headers = {
        "Authorization": PEXELS_API_KEY
    }
    params = {
        "query": random.choice(SEARCH_TERMS),
        "orientation": random.choice(ORIENTATION_OPTIONS),
        "size": SIZE,
        "per_page": PER_PAGE,
        "page": random.randint(1, 5)  # Try a few initial pages for more variety
    }

    try:
        response = requests.get(base_url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()

        if data.get('photos'):
            random_photo = random.choice(data['photos'])
            return random_photo['src'][SIZE]
        else:
            print("Could not retrieve image URL from Pexels response.")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching image URL from Pexels: {e}")
        return None
    except json.JSONDecodeError:
        print("Error decoding JSON response from Pexels.")
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
        print(f"Image downloaded successfully from Pexels to {save_path}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"Error downloading image: {e}")
        return False

if __name__ == "__main__":
    image_url = fetch_random_pexels_image_url()
    if image_url:
        download_image(image_url, DOWNLOAD_PATH)
