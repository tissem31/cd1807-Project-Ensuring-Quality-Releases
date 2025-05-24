#!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By

def login(user, password):
    print('Starting the browser...')
    options = ChromeOptions()
    # Uncomment for headless in Azure DevOps/Linux VM
    # options.add_argument("--headless")
    # options.add_argument("--no-sandbox")
    # options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(options=options)
    print('Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')

    print(f"Attempting login with user: {user}")
    driver.find_element(By.ID, "user-name").send_keys(user)
    driver.find_element(By.ID, "password").send_keys(password)
    driver.find_element(By.ID, "login-button").click()

    if "inventory" in driver.current_url:
        print("Login successful")
        return driver
    else:
        print("Login failed")
        driver.quit()
        return None

# Test login independently (optional)
if __name__ == "__main__":
    driver = login('standard_user', 'secret_sauce')
    if driver:
        print("Closing browser after successful login test.")
        driver.quit()
