require 'json'
require_relative '../../lib/game_state_validation'

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
    @game = Game.new({ type: GAME_TYPES[params[:game_type]] })
    if @game.save
      session[:game_token] = @game.token
      redirect_to game_path(@game)
    else
      redirect_to new_game_path
    end
  end

  def show
    @board_state = @game.board_state.to_json
  end

  def move
    @game.board_state = params[:board_state] # GameStrategizer.new(params[:board_state]).devise_move
    @game.save
    render_board_state_json(:ok)
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end

  def check_token
    redirect_to new_game_path and return unless valid_player?
  end

  def check_board_state
    render_board_state_json(422) and return unless valid_board_state?
  end

  def render_board_state_json(status)
    render(json: @game.board_state.to_json, status: status) 
  end

  def valid_player?
    session[:game_token] == @game.token
  end

  def valid_board_state?
    GameStateValidation.new(@game.board_state, params[:board_state]).valid?
  end 
  # don't forget when testing strategy algorithm: computer should never be able to beat itself!
end
