require 'json'
require 'open-uri'

class GamesController < ApplicationController


  def new
    @letters = Array.new(10) { (('A'..'Z').to_a).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @grid_word = inside_grid?(@word, @letters)
    @english_word = english_word?(@word)
    @score = final_score(@word)
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    return user['found']
  end

  def inside_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter.capitalize) }
  end

  def final_score(word)
    word.size**2 + params[:start_time] - params[:end_time]
  end
end
