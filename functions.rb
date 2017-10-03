# This contains global functions that can be used in other tests

def select_dropdown(options, language)
  options.each { |option| option.click if option.text == language }
end
