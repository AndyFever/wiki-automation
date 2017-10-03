# This contains global functions that can be used in other tests

def select_dropdown(options, language)
  options.each do |option|
    if option.text == language
      option.click
      break
    end
  end
end
