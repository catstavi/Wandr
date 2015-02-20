class KeyPhrases
  def self.extract_phrases(text)
    text.downcase.strip.gsub(/[^A-Za-z0-9\s]/, '')
    response = HTTParty.post("https://textanalysis.p.mashape.com/textblob-noun-phrase-extraction",
        :headers => { 'X-Mashape-Key' => ENV["MASHAPE_KEY"] } ,
        :body => "text= #{text}")
    nouns = response.parsed_response["noun_phrases"].uniq
    banned_words = %w[anyway thanks please this as at below for from of off onto over past per minus onto down not theres there thats is be was have has am are were been all on but and though tho in by under above onto into ive im ill hes shes wont cant hadnt havent wouldve couldnt shouldnt sure went stay lots]
    nouns = nouns.collect {|noun| noun unless banned_words.include? noun }
    nouns.join(', ')
  end
end
