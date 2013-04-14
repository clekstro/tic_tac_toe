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
    @game.board_state = params[:board_state]
    @game.save
    render :json => @game.board_state.to_json, status: :ok
  end

  private

  def find_game
    @game = Game.find(params[:id])
  end

  def check_token
    redirect_to new_game_path and return unless valid_player?
  end

  def check_board_state
    redirect_to game_path(@game) and return unless valid_board_state?
  end

  def valid_player?
    session[:game_token] == @game.token
  end

  def valid_board_state?
    GameStateValidation.new(@game.board_state, params[:board_state]).valid?
  end 
  # don't forget when testing strategy algorithm: computer should never be able to beat itself!
end
