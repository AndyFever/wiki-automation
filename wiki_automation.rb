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
  yield
  teardown
end

run do
  
end
