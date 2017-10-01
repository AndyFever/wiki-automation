require 'selenium-webdriver'
require 'wrong'
include Wrong

def setup
  @driver = Selenium::WebDriver.for :chrome
end

def teardown
  @driver.quit
end

def run
  setup
  setup_tests
  yield
  teardown
end

run do
  @driver.get @wikipedia[:url]
  assert {@driver.title == @wikipedia[:title]}
  searchBox = @driver.find_element(:css, '#searchInput')
  searchBox.send_keys(@wikipedia[:search_term])
  select = @driver.find_element(:css, '#searchLanguage')
  drop_down = select.find_elements(:tag_name, "option")
  drop_down.each do |option|
    if option.text == @wikipedia[:language]
      option.click
      break
    end
  end

  @driver.find_element(:xpath, '//*[@id="search-form"]/fieldset/button').click
  assert {@driver.find_element(:css, '#firstHeading').text == @wikipedia[:search_term] || @wikipedia[:search_term].capitalize}
  assert {(@driver.find_element(:css, '#mw-content-text').text.include? @wikipedia[:text]) ==  true}
end
