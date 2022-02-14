require 'open-uri'

class GamesController < ApplicationController
  def game
    @alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters.push(@alphabet.sample) }
  end

  def result
    @answer = params[:attempt].upcase
    @filepath = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    @word = URI.open(@filepath).read
    @word_check = JSON.parse(@word)
    @grid = params[:letters].split(' ')
    @result = check_valid(@word_check, @grid)
  end

  def check_valid(word_check, grid)
    # return 'Invalid word' if TODO ADD CASE WHERE INPUT IS ""
    upcase_guess = word_check['word'].upcase
    session[:score] = 0 unless word_check['found'] && word_check['word'].length <= grid.length
    return 'Invalid word' unless word_check['found'] && word_check['word'].length <= grid.length

    amt_letters = upcase_guess.chars.all? { |letter| (upcase_guess.count(letter)) <= grid.count(letter) }
    # first, checks if the word exists, then checks if its shorter or of equal length to the grid. you get invalid word in either case.
    right_letters = upcase_guess.chars.all? { |letter| grid.include?(letter) }
    # then, checks if each letter is used either the same amount or less times of that in the grid
    session[:score] = 0 unless amt_letters && right_letters
    return 'Invalid word' unless amt_letters && right_letters

    @score = upcase_guess.length
    session[:score] = 0 if session[:score].nil? # just reassigns it to 0 at the start
    session[:score] += @score
    @total_score = session[:score]
    "Your guess, #{upcase_guess} was a valid guess!"
  end
end
