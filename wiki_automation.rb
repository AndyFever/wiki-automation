require 'selenium-webdriver'
require 'wrong'
include Wrong
require 'pry'
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

def setup_tests
  wikipedia_english = {url: 'http://wikipedia.org',
                        title: 'Wikipedia',
                        search_term: 'fish',
                        text: 'Fish are the gill-bearing aquatic craniate animals that lack limbs with digits',
                        language: 'English'}
  wikipedia_dutch = {url: 'http://wikipedia.org',
                        title: 'Wikipedia',
                        search_term: 'Frankreich',
                        text: 'Die Fläche der gesamten Französischen Republik',
                        language: 'Deutsch'}

@all_tests = []
@all_tests.push(wikipedia_english)
@all_tests.push(wikipedia_dutch)
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
    drop_down = select.find_elements(:tag_name, "option")
    drop_down.each do |option|
      if option.text == test[:language]
        option.click
        break
      end
    end

    @driver.find_element(:xpath, '//*[@id="search-form"]/fieldset/button').click

    # Check the fist heading matches the search string
    assert {@driver.find_element(:css, '#firstHeading').text == test[:search_term] || test[:search_term].capitalize}

    # Check the page is displayed in English
    assert {(@driver.find_element(:css, '#mw-content-text').text.include? test[:text]) ==  true}
  end
end
