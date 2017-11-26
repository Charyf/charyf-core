require_relative 'base'

module Charyf
  module Utils
    module Parser
      # noinspection RubyLiteralArrayInspection,RubyQuotedStringsInspection
      # English string normalization
      class English < Base

        strategy_name :en

        CONTRACTION = ["ain't", "aren't", "can't", "could've", "couldn't",
                       "didn't", "doesn't", "don't", "gonna", "gotta",
                       "hadn't", "hasn't", "haven't", "he'd", "he'll", "he's",
                       "how'd", "how'll", "how's", "I'd", "I'll", "I'm",
                       "I've", "isn't", "it'd", "it'll", "it's", "mightn't",
                       "might've", "mustn't", "must've", "needn't", "oughtn't",
                       "shan't", "she'd", "she'll", "she's", "shouldn't",
                       "should've", "somebody's", "someone'd", "someone'll",
                       "someone's", "that'll", "that's", "that'd", "there'd",
                       "there're", "there's", "they'd", "they'll", "they're",
                       "they've", "wasn't", "we'd", "we'll", "we're", "we've",
                       "weren't", "what'd", "what'll", "what're", "what's",
                       "whats",
                       "what've", "when's", "when'd", "where'd", "where's",
                       "where've", "who'd", "who'd've", "who'll", "who're",
                       "who's", "who've", "why'd", "why're", "why's", "won't",
                       "won't've", "would've", "wouldn't", "wouldn't've",
                       "y'all", "ya'll", "you'd", "you'd've", "you'll",
                       "y'aint", "y'ain't", "you're", "you've"].map(&:downcase).freeze

        EXPANSION = ["is not", "are not", "can not", "could have",
                     "could not", "did not", "does not", "do not",
                     "going to", "got to", "had not", "has not",
                     "have not", "he would", "he will", "he is", "how did",
                     "how will", "how is", "I would", "I will", "I am",
                     "I have", "is not", "it would", "it will", "it is",
                     "might not", "might have", "must not", "must have",
                     "need not", "ought not", "shall not", "she would",
                     "she will", "she is", "should not", "should have",
                     "somebody is", "someone would", "someone will",
                     "someone is", "that will", "that is", "that would",
                     "there would", "there are", "there is", "they would",
                     "they will", "they are", "they have", "was not",
                     "we would", "we will", "we are", "we have",
                     "were not", "what did", "what will", "what are",
                     "what is",
                     "what is", "what have", "when is", "when did",
                     "where did", "where is", "where have", "who would",
                     "who would have", "who will", "who are", "who is",
                     "who have", "why did", "why are", "why is",
                     "will not", "will not have", "would have",
                     "would not", "would not have", "you all", "you all",
                     "you would", "you would have", "you will",
                     "you are not", "you are not", "you are", "you have"].map(&:downcase).freeze

        TEXT_NUMBERS = ["zero", "one", "two", "three", "four", "five", "six",
                       "seven", "eight", "nine", "ten", "eleven", "twelve",
                       "thirteen", "fourteen", "fifteen", "sixteen",
                       "seventeen", "eighteen", "nineteen", "twenty"].map(&:downcase).freeze

        ARTICLES = ["the", "a", "an"].map(&:downcase).freeze

        def self.normalize(text, remove_articles: true)
          words = text.split

          normalized = ''

          words.each do |word|
            next if word.empty?
            next if remove_articles && ARTICLES.include?(word.downcase)

            # Expand common contractions, e.g. "isn't" -> "is not"
            if CONTRACTION.include?(word.downcase)
              capitalize = false
              if word[0] == word[0].upcase
                capitalize = true
              end
              word = EXPANSION[CONTRACTION.index(word.downcase)]

              word.capitalize! if capitalize
            end

            if TEXT_NUMBERS.include?(word.downcase)
              word = TEXT_NUMBERS.index(word.downcase)
            end

            normalized += " " + word
          end

          normalized.strip
        end

      end
    end
  end
end