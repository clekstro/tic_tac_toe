class PlayerValidation
  def initialize(session, game)
    @session = session
    @game = game
  end

  def valid?
    case(@game.class.name)
    when "ComputerGame"
      matching_game_token?
    when "HumanGame"
      matching_game_token? && matching_user_token?
    end
  end

  private

  def matching_game_token?
    @session[:game_token] == @game.token
  end

  def matching_user_token?
    [@game.player_id, @game.opponent_id].include? @session[:user_token]
  end

end
