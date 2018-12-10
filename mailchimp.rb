# 1. Start scenario on https://mailchimp.com/
# 2. Navigate to Mailchimp's "Our Story" page
# 3. Then click on the "Learn more about our leadership team." link
# 4. Next, save each leadership team members name, position, and description into a .csv file.
# 5. End scenario

require 'csv'
require 'selenium-webdriver'

# Initialize driver
driver = Selenium::WebDriver.for :firefox
url = 'https://mailchimp.com/'

# Set timeout
wait = Selenium::WebDriver::Wait.new(timeout: 10)

# Go to url
driver.navigate.to url

# Maximize window
driver.manage.window.maximize

# Scroll to bottom of page and click our story link
driver.execute_script('window.scrollTo(0, document.body.scrollHeight)')
our_story = wait.until { driver.find_element(:xpath, '/html/body/footer/div/div/nav/ul/li[1]/a') }
our_story.click

# When Our Story page loads, scroll down and click leadership link when it is seen
wait.until { driver.find_element(:xpath, '/html/body/main/section[1]/div/div/h1') }
leadership = wait.until { driver.find_element(:xpath, '/html/body/main/section[5]/div/div/div/p[5]/a') }
driver.action.key_down(:page_down).perform unless leadership.click

# When Our Leadership page loads, store and format data to be inserted into a csv
wait.until { driver.find_element(:xpath, '/html/body/main/section[1]/div/div/h2') }
bio_list = driver.find_element(:xpath, '//*[@id="content"]/section[2]/div').text
bio_formatter = bio_list.tr(',', ':').tr("\n", ',')
bio_split = bio_formatter.split(',').to_a
leadership = bio_split.each_slice(3).to_a
counter = 0
count = bio_formatter.split('.,').count

# Write leadership data to a csv
CSV.open('leadership.csv', 'w') do |csv|
  csv << %w(Name Position Description)
  count.times do
    # leadership[counter][2]
    csv << [leadership[counter][0].to_s,
            leadership[counter][1].to_s,
            leadership[counter][2].tr(':', ',').to_s]
    counter += 1
  end
end

driver.close
