require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (('A'..'Z').to_a * 30).sample(10)
  end

  def score
    @word = params[:word]
    @grid = params[:letters]
    @result = if included?(@word.upcase, @grid) && word?(@word)
                "Congratulations #{@word.upcase} is a valid English Word"
              elsif included?(@word.upcase, @grid) == true
                "Sorry but #{@word.upcase} is not a word"
              else
                "Sorry but #{@word.upcase} can't be build out of #{@grid}"
              end
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word.strip.downcase}")
    json = JSON.parse(response.read)
    json['found']
  end
end
