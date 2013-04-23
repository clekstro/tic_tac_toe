require 'securerandom'
require_relative '../app/models/game'

class GameFactory
  def initialize(params, session)
    @params = params
    @session = session
  end

  def game
    case(@params[:game_type])
    when "computer"
      return computer_game
    when "human"
      return human_game
    end
  end

  private

  def computer_game
    Game.new({type: "ComputerGame"})
  end

  def human_game
    require 'pry'; binding.pry
    game_exists? ? existing_game : new_game
  end

  def existing_game
    set_token_for(HumanGame.where(opponent_id: nil).first)
  end

  def new_game
    set_token_for(HumanGame.new)
  end

  def set_token_for(game)
    opponent_token = SecureRandom.hex(64)
    game.opponent_id = opponent_token
    @session[:user_token] = opponent_token
    game
  end

  def game_exists?
    HumanGame.where(opponent_id: nil).count > 0
  end

end
