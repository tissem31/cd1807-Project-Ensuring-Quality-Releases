#!/usr/bin/env python3
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException, TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from login import login

def add_all_products(driver):
    print("Adding all products to the cart...")
    added_products = []

    try:
        WebDriverWait(driver, 10).until(EC.presence_of_all_elements_located((By.CLASS_NAME, "inventory_item")))
        products = driver.find_elements(By.CLASS_NAME, "inventory_item")

        for product in products:
            try:
                title = product.find_element(By.CLASS_NAME, "inventory_item_name").text
                add_button = product.find_element(By.CLASS_NAME, "btn_inventory")
                add_button.click()
                print(f"Added to cart: {title}")
                added_products.append(title)
            except NoSuchElementException:
                print("Could not add a product to the cart.")

    except TimeoutException:
        print("Timed out waiting for product list to load.")

    return added_products

def go_to_cart(driver):
    try:
        cart_link = WebDriverWait(driver, 5).until(
            EC.element_to_be_clickable((By.CLASS_NAME, "shopping_cart_link"))
        )
        cart_link.click()
        WebDriverWait(driver, 5).until(
            EC.presence_of_element_located((By.CLASS_NAME, "cart_item"))
        )
    except TimeoutException:
        print("Cart page did not load in time.")

def remove_all_products(driver):
    print("Removing all products from the cart...")
    removed_products = []

    try:
        remove_buttons = driver.find_elements(By.CLASS_NAME, "cart_button")
        for btn in remove_buttons:
            try:
                cart_item = btn.find_element(By.XPATH, "./ancestor::div[@class='cart_item']")
                product_name = cart_item.find_element(By.CLASS_NAME, "inventory_item_name").text
                btn.click()
                print(f"Removed from cart: {product_name}")
                removed_products.append(product_name)
            except NoSuchElementException:
                print("Could not remove a product from the cart.")
    except Exception as e:
        print(f"Unexpected error while removing products: {e}")

    return removed_products

def main():
    user = "standard_user"
    password = "secret_sauce"
    driver = None

    try:
        driver = login(user, password)
        if not driver:
            print("Exiting due to failed login.")
            return

        added_products = add_all_products(driver)

        go_to_cart(driver)
        removed_products = remove_all_products(driver)

        print("\nSummary:")
        print(f"User logged in: {user}")
        print(f"Products added to cart ({len(added_products)}): {added_products}")
        print(f"Products removed from cart ({len(removed_products)}): {removed_products}")

        driver.save_screenshot("final_cart_state.png")
        print("Screenshot saved as final_cart_state.png")

    finally:
        if driver:
            driver.quit()
            print("Browser closed. Test complete.")

if __name__ == "__main__":
    main()
