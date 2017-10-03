require 'selenium-webdriver'
require 'wrong'
require 'pry'
require_relative 'test_data'
require_relative 'functions'
include Wrong

=begin

Setup Requirements
------------------

Ruby Version: 2.3.1
Selenium Webdriver v 3.6.0
Chromedriver
'Wrong' Assertion Library 'https://github.com/sconover/wrong'

=end

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
  @all_tests.each do |test|
    @driver.get test[:url]
    assert {@driver.title == test[:title]}
    searchBox = @driver.find_element(:css, '#searchInput')
    searchBox.send_keys(test[:search_term])
    select = @driver.find_element(:css, '#searchLanguage')
    @drop_down = select.find_elements(:tag_name, "option")
    select_dropdown(@drop_down, test[:language])
    @driver.find_element(:xpath, '//*[@id="search-form"]/fieldset/button').click

    # Check the fist heading matches the search string
    assert {@driver.find_element(:css, '#firstHeading').text == test[:search_term] || test[:search_term].capitalize}

    # Check the page is displayed in English
    assert {(@driver.find_element(:css, '#mw-content-text').text.include? test[:text]) ==  true}
  end
end
