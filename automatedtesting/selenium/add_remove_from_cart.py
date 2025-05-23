from login import login
from selenium.webdriver.common.by import By
import time
import logging

# Configure logging
logging.basicConfig(filename='selenium.log', level=logging.INFO, format='%(asctime)s - %(message)s')

# Redirect prints to selenium-output.txt
import sys
sys.stdout = open('selenium-output.txt', 'w')

driver = login()

# Ajouter tous les produits au panier
products = driver.find_elements(By.CLASS_NAME, "inventory_item")
print(f"Found {len(products)} products. Adding all to cart.")
logging.info(f"Adding {len(products)} products to cart.")

for item in products:
    add_button = item.find_element(By.TAG_NAME, "button")
    print(f"Adding: {item.find_element(By.CLASS_NAME, 'inventory_item_name').text}")
    logging.info(f"Adding: {item.find_element(By.CLASS_NAME, 'inventory_item_name').text}")
    add_button.click()

time.sleep(1)

# Retirer tous les produits
print("Removing all items from the cart.")
logging.info("Removing all items from the cart.")
remove_buttons = driver.find_elements(By.XPATH, "//button[text()='Remove']")
for btn in remove_buttons:
    btn.click()

time.sleep(2)
print("All items removed from cart.")
logging.info("All items removed from cart.")

driver.quit()
