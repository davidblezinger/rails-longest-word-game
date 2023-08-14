require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    grid_size = 10
    @letters = []
    grid_size.times do
      @letters.push(('A'..'Z').to_a.sample)
    end
  end

  def score
    @attempt = params[:word]
    @grid = params[:letters].split(' ')
    @score = 0
    @message = ""
    attempt_array = @attempt.upcase.chars
    match_grid = match_grid?(attempt_array, @grid)
    answer = get_answer(@attempt)
    return_result(answer, match_grid, attempt_array)
  end

  private

  def match_grid?(attempt_array, grid)
    match_grid = true
    attempt_array.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        match_grid = false
      end
    end
    match_grid
  end

  def get_answer(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    answer_serialized = URI.open(url).read
    JSON.parse(answer_serialized)
  end

  def return_result(answer, match_grid, attempt_array)
    if answer["found"] == false || match_grid == false
      @message = "not in the grid" if match_grid == false
      @message = "not an english word" if answer["found"] == false
    else
      @score = attempt_array.length
      @message = "well done"
    end
  end
end
