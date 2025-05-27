
#!/usr/bin/env python
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import time
from login import login

def add_all_products(driver):
    print("Adding all products to the cart...")
    products = driver.find_elements(By.CLASS_NAME, "inventory_item")
    added_products = []
    for product in products:
        try:
            title = product.find_element(By.CLASS_NAME, "inventory_item_name").text
            add_button = product.find_element(By.CLASS_NAME, "btn_inventory")
            add_button.click()
            print(f"Added to cart: {title}")
            added_products.append(title)
            time.sleep(0.5)  # slight pause between actions
        except NoSuchElementException:
            print("Could not add product to cart.")
    return added_products

def remove_all_products(driver):
    print("Removing all products from the cart...")
    driver.find_element(By.CLASS_NAME, "shopping_cart_link").click()
    time.sleep(2)
    remove_buttons = driver.find_elements(By.CLASS_NAME, "cart_button")
    removed_products = []
    for btn in remove_buttons:
        try:
            # The product name is sibling to the remove button in cart items
            cart_item = btn.find_element(By.XPATH, "./ancestor::div[@class='cart_item']")
            product_name = cart_item.find_element(By.CLASS_NAME, "inventory_item_name").text
            btn.click()
            print(f"Removed from cart: {product_name}")
            removed_products.append(product_name)
            time.sleep(0.5)
        except NoSuchElementException:
            print("Could not remove product from cart.")
    return removed_products

def main():
    user = "standard_user"
    password = "secret_sauce"

    driver = login(user, password)
    if not driver:
        print("Exiting due to failed login.")
        return

    added_products = add_all_products(driver)

    # Navigate to cart
    driver.find_element(By.CLASS_NAME, "shopping_cart_link").click()
    time.sleep(2)

    removed_products = remove_all_products(driver)

    print("\nSummary:")
    print(f"User logged in: {user}")
    print(f"Products added to cart ({len(added_products)}): {added_products}")
    print(f"Products removed from cart ({len(removed_products)}): {removed_products}")

    # Optional screenshot at the end
    driver.save_screenshot("final_cart_state.png")
    print("Screenshot saved as final_cart_state.png")

    driver.quit()
    print("Browser closed. Test complete.")

if __name__ == "__main__":
    main()
