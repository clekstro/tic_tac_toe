require_relative 'board'
require_relative 'board_parser'
require_relative 'computer_strategy'

class MoveManager
  def initialize(game, board_state)
    @game = game
    @board_state = board_state
  end

  def new_state
    case(@game.class.name)
    when "ComputerGame"
      computer_move
    when "HumanGame"
      @board_state
    end
  end

  private

  def computer_move
    board = Board.new(@board_state)
    parser = BoardParser.new({board: board})
    @board_state[ComputerStrategy.new(parser).best_move] = "O"
    @board_state
  end

end
