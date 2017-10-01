require 'selenium-webdriver'
require 'wrong'
include Wrong

=begin
Setup Instructions
------------------

Ruby Version: 2.3.1
Selenium Webdriver v 3.6.0
'Wrong' Assertion Library 'https://github.com/sconover/wrong'

=end

def setup
  @driver = Selenium::WebDriver.for :chrome
end

def teardown
  @driver.quit
end

def setup_tests
  @wikipedia = {url: 'http://wikipedia.org',
                title: 'Wikipedia',
                search_term: 'fish',
                text: 'Fish are the gill-bearing aquatic craniate animals that lack limbs with digits',
                language: 'English'}
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

  # Check the fist heading matches the search string
  assert {@driver.find_element(:css, '#firstHeading').text == @wikipedia[:search_term] || @wikipedia[:search_term].capitalize}

  # Check the page is displayed in English
  assert {(@driver.find_element(:css, '#mw-content-text').text.include? @wikipedia[:text]) ==  true}
end
