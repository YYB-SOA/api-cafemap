from sys import argv
import sys

import time
import subprocess

from selenium import webdriver
from selenium.webdriver.chrome.service import Service


def scrape_comments(store_name, chromedriver_path):
    # Create a Service object using the path to the ChromeDriver executable
    service = Service(chromedriver_path)
    process = subprocess.Popen(['chromedriver', '--port=9515'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    # Wait for the process to start
    print("Start the service \n\n")
    service.start()
    print("Service turn-on completed \n\n")
    # Start Chrome browser
    driver = webdriver.Chrome(service=service)
    
    # Navigate to Google Maps
    try:
        driver.get("https://www.google.com/maps")
        print("Successfully navigated to Google Maps")
    except Exception as e:
        print("Error navigating to Google Maps:", e)
        return

    time.sleep(5)

    # Check the return code
    if process.poll() is None:
        print("ChromeDriver service started successfully")
    else:
        print("ChromeDriver service failed to start")
    # Wait for page to load
    time.sleep(3)


    # Find the search box and enter the store name
    try:
        search_box = driver.find_element_by_name("q")
        search_box.send_keys(store_name)
        print("Successfully entered store name in search box")
    except Exception as e:
        print("Error entering store name in search box:", e)
        return
     # Wait for search results to load
    time.sleep(3)

    # Click on the first result
    try:
        first_result = driver.find_element_by_css_selector(".section-result:first-of-type")
        first_result.click()
        print("Successfully clicked on first result")
    except Exception as e:
        print("Error clicking on first result:", e)
        return
    # Wait for the store page to load
    time.sleep(3)

    # Find the "Reviews" tab and click on it


store_name = sys.argv[1]

comments = scrape_comments(store_name, "/mnt/c/Users/LeoShr/p_space/NTHU/2022_SOA/group_proj/api-cafemap/lib/chromedriver.exe")
print(comments)