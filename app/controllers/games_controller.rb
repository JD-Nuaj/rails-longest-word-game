require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array('A'..'Z').sample(10)
  end

  def score
    user_word = params[:word].upcase.strip
    letters = params[:letters].split(',')

    if can_form_word?(user_word, letters)
      url = "https://dictionary.lewagon.com/#{user_word.downcase}"
      response = Net::HTTP.get(URI(url))
      data = JSON.parse(response)

      if data["found"] == true
        @result = "English and valid!"
        @score = user_word.length
      else
        @result = "Valid but not english!"
        @score = 0
      end
    else
      @result = "Oups, this word can't be create with th grid"
      @score = 0
    end
  end

  private

  def can_form_word?(word, letters)
    word.split('').all? { |letter| word.count(letter) <= letters.count(letter) }
  end
end
