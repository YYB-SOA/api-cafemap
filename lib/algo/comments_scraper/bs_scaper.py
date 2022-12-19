import requests 
import json

import time
# pip install selenium
# pip install bs4
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.chrome.options import Options

from bs4 import BeautifulSoup
from selenium.webdriver.chrome.service import Service

import subprocess
import sys
# 開啟瀏覽器視窗(Chrome)
# 方法一：執行前需開啟chromedriver.exe且與執行檔在同一個工作目錄
store_name = sys.argv[1]
store_name

def search_store(store_name):
    # Set the path to the ChromeDriver executable
    chromedriver_path = "lib/chromedriver_linux64"
    chrome_options = Options()
    chrome_options.add_argument("--headless")

    # Set the desired capabilities for the ChromeDriver
    caps = DesiredCapabilities.CHROME.copy()
    caps['goog:loggingPrefs'] = {'browser': 'ALL'}

    # Start the ChromeDriver service

    service = Service(chromedriver_path)
    # process = subprocess.Popen(['chromedriver', '--port=9515'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    # # Wait for the process to start
    print("Start the service \n\n")

    # Create a new Chrome browser instance
    driver = webdriver.Chrome(service = service, desired_capabilities=caps, options=chrome_options)
    
    # Navigate to Google Maps
    # try:
    # Maximize the window and navigate to Google Maps
    driver.maximize_window()
    driver.get("https://www.google.com/maps")
    print("Successfully navigated to Google Maps")
    # except Exception as e:
    #     print("Error navigating to Google Maps:", e)
    #     return

    # Find the search input element and enter the store name
    element = driver.find_element(By.ID, "searchboxinput")
    element.send_keys(store_name)
    element.send_keys(Keys.ENTER)

    # Wait for the search results to load
    time.sleep(3)

    # Find and click the first search result
    element = driver.find_element(By.XPATH, '//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]/div[1]/div[1]/div/a')
    element.send_keys(Keys.ENTER)

    # Wait for the page to load
    time.sleep(2)

    # Find and click the "Category" button
    element = driver.find_element(By.CLASS_NAME, "DkEaL")
    element.click()

    # Wait for the category menu to load
    time.sleep(2)

    # Find and click the
    category_click = driver.find_elements(By.CLASS_NAME, "GMtm7c.fontTitleSmall")[1]
    category_click.click()
    category_click = driver.find_elements(By.CLASS_NAME, "fxNQSd")[1]
    category_click.click()
    time.sleep(3)

    for i in range(1, 12):
        pane = driver.find_element(By.CLASS_NAME, 'm6QErb.DxyBCb.kA9KIf.dS8AEf')
        driver.execute_script("arguments[0].scrollTop = arguments[0].scrollHeight", pane)
        time.sleep(1)
    soup = BeautifulSoup(driver.page_source, "html")
    for i in range(1, len(driver.find_elements(By.CLASS_NAME, "wiI7pd"))+1):
        print(driver.find_elements(By.CLASS_NAME, "wiI7pd")[i].text)
    driver.close()
    driver.close()

store_name = sys.argv[1]

def main(input):
    return search_store(input)

main(store_name)
