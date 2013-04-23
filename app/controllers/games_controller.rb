require 'json'
require_relative '../../lib/game_state_validation'
require_relative '../../lib/computer_strategy'
require_relative '../../lib/board'
require_relative '../../lib/player_validation'

class GamesController < ApplicationController
  before_filter :find_game, only: [:show, :move]
  before_filter :check_token, only: [:show, :move]
  before_filter :check_board_state, only: [:move]

  GAME_TYPES = {"human" => "HumanGame", "computer" => "ComputerGame"}

  def new
    @game = Game.new
    @game_types = GAME_TYPES.keys
  end

  def create
    @game = GameFactory.new(params, session).game
    if @game.save
      session[:game_token] = @game.token
      redirect_to game_path(@game)
    else
      redirect_to new_game_path
    end
  end

  def show
    @board_state = @game.board_state.to_json
    @game_types = GAME_TYPES.keys
  end

  def move
    @game.board_state = new_board_state
    @game.save

    render_board_state_json(:ok)
  end

  private

  def find_game
    @game = Game.find(params[:id])
    @parser = BoardParser.new({board: Board.new(@game.board_state)})
  end

  def check_token
    redirect_to new_game_path and return unless valid_player?
  end

  def check_board_state
    render_board_state_json(422) and return unless valid_board_state?
  end

  def render_board_state_json(status)
    render(json: {boardState: @game.board_state, gameOver: @parser.game_over?, winningRow: @parser.winning_row_spaces}.to_json, status: status)
  end

  def valid_player?
    PlayerValidation.new(session, @game).valid?
  end

  def valid_board_state?
    GameStateValidation.new(@game.board_state, params[:board_state]).valid?
  end

  def new_board_state
    new_state = MoveManager.new(@game, params[:board_state]).new_state
    @parser = BoardParser.new({board: Board.new(new_state)})
    new_state
  end

end
