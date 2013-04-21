require_relative 'board'
require "active_support/core_ext/object/blank"

class BoardParser
  attr_accessor :board, :board_state, :opponent, :computer

  def initialize(options={})
    @board = options[:board] || Board.new
    @board_state = @board.board_state
    @opponent = options[:opponent] || "X"
    raise InvalidOpponentError unless @opponent.match(/[XO]/)
    @computer = opponent_for(@opponent)
  end

  def open_spaces
    rows_where { |k,v| v.blank? }.keys
  end

  def random_open_space
    open_spaces.sample
  end

  def opening_move?
    @board_state.count{ |k,v| !v.blank? } == 1
  end

  def secondary_move?
    @board_state.count{ |k,v| !v.blank? } == 2
  end

  def own_moves
    @board_state.reject { |k,v| v.blank? || v == @opponent }.keys
  end

  def opponent_moves
    rows_where { |k,v| v == @opponent }.keys
  end

  def opponent_free_rows
    @board.all_rows.select { |row| (row & opponent_moves).size == 0 }
  end

  def opponent_free_rows_for_player(player)
    opponent = opponent_for(player)
    @board.all_rows.select { |row| (row & moves_for(opponent)).size == 0 }
  end

  def corner
    @board.corners.sample
  end

  def edges
    ["A2","B1","B3","C2"]
  end

  def defeat_iminent?
    any_rows? { |row| row_defeatable?(row) }
  end

  def victory_iminent?
    any_rows? { |row| row_conquerable?(row) }
  end

  def fork_possible_for?(player)
    open_spaces.each do |move|
      return true if move_creates_fork_for?(move, player)
    end
    false
  end

  def move_creates_fork_for?(potential_move, player)
    simulated_state = simulated_move_for(potential_move, player)
    potential_moves = simulated_state.select { |k,v| v == player }.keys
    opponent_free_rows_for_player(player).count{ |row| (row & potential_moves).size == 2 && row.include?(potential_move) } > 1
  end

  def game_over?
    any_rows? { |row| row_taken?(row) } || open_spaces == []
  end

  def winning_row_spaces
    row = find_row { |row| row_taken?(row) }
    return row ? row : []
  end

  def winning_row
    find_row { |row| row_conquerable?(row) }
  end

  def losing_row
    find_row { |row| row_defeatable?(row) }
  end

  private

  def moves_for(board_state=@board_state, player)
    board_state.select { |k,v| v == player }.keys
  end

  def opponent_for(player)
    player == "X" ? "O" : "X"
  end

  def simulated_move_for(move, player)
    simulated_state = @board_state.dup
    simulated_state[move] = player
    simulated_state
  end

  def any_rows?(&block)
    @board.all_rows.any? &block
  end

  def find_row(&block)
    @board.all_rows.detect &block
  end

  def rows_where(&block)
    @board_state.select &block
  end

  def row_conquerable?(row)
    (row & own_moves).size == 2 && (row & opponent_moves).size < 1
  end

  def row_defeatable?(row)
    (row & opponent_moves).size == 2 && (row & own_moves).size < 1
  end

  def row_taken?(row)
    (row & opponent_moves).size == 3 || (row & own_moves).size == 3
  end

end

class InvalidOpponentError < StandardError
end
