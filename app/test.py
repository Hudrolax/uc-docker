from selenium.webdriver.common.by import By
import undetected_chromedriver as uc
import os
from time import sleep


current_dir = os.getcwd()
target_url = 'https://nowsecure.nl'

# make blank HTML filw with one link to direct URL
# it's need for pass cloudflare
with open('blank.html', 'w') as f:
    f.write(f'<a href="{target_url}" target="_blank">link</a>')

driver = uc.Chrome(headless=False, use_subprocess=False)
driver.get(f'file://{current_dir}/blank.html')
# you need to sleep several seconds after start the browser before you
# can open cloudflare protected page
sleep(10)

# and then you can click to the link and open your target URL
links = driver.find_elements(By.XPATH, "//a[@href]")
links[0].click()

# after opening the URL, we need to sleep during cloudflare chacking the browser
sleep(15)

# and last step: switch the driver to second tab in the browser
# it's need for managing page by the driver
driver.switch_to.window(driver.window_handles[1])

# take a screenshot to /app dir
driver.save_screenshot('nowsecure.png')
