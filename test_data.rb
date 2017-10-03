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
