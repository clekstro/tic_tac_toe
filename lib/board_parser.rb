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

  def open_spaces(board_state=@board_state)
    rows_where(board_state) { |k,v| v.blank? }.keys
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

  def player_turn?(player)
    (player == "X" && equal_move_count?) ||
      (player == "O" && (moves_for("O").size == moves_for("X").size - 1))
  end

  def corner_available?(board_state=@board_state)
    !(@board.corners & open_spaces(board_state)).empty?
  end

  def center_open?
    @board_state["B2"] == ""
  end

  def makes_two_in_a_row?(move, player)
    @board.all_rows.any? { |row| creates_connected_moves_for?(row, move, player) }
  end

  def own_moves(board_state=@board_state)
    board_state.reject { |k,v| v.blank? || v == @opponent }.keys
  end

  def opponent_moves(board_state=@board_state)
    rows_where(board_state){ |k,v| v == @opponent }.keys
  end

  def opponent_free_rows(board_state=@board_state)
    @board.all_rows.select { |row| (row & opponent_moves(board_state)).size == 0 }
  end

  def opponent_free_rows_for_player(board_state=@board_state, player)
    opponent = opponent_for(player)
    @board.all_rows.select { |row| (row & moves_for(board_state, opponent)).size == 0 }
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

  def fork_possible_for?(board_state=@board_state,player)
    open_spaces(board_state).each do |move|
      return true if move_creates_fork_for?(move, player)
    end
    false
  end

  def move_creates_fork_for?(board_state=@board_state, potential_move, player)
    simulated_state = simulated_move_for(potential_move, player)
    potential_moves = simulated_state.select { |k,v| v == player }.keys
    opponent_free_rows_for_player(board_state, player).count{ |row| (row & potential_moves).size == 2 && row.include?(potential_move) } > 1
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

  def opponent_in_corner?
    !(opponent_moves & @board.corners).empty?
  end

  def opposite_corner_available?(board_state=@board_state)
    return false if !opponent_in_corner?
    open_spaces(board_state).include? opposite_corner_from(@opponent)
  end

  def opposite_corner_from(opponent)
    opponent_corner = (opponent_moves & @board.corners).first
    @board.opposite_corner(opponent_corner)
  end

  def forks(fork_moves, player)
    forks = []
    fork_moves.each do |potential_move|
      forks << fork_keys_for(fork_moves, potential_move, player)
    end
    forks.flatten.uniq
  end

  def fork_keys_for(moves, potential_move, player)
    state = simulated_move_for(potential_move, player)
    potential_moves = state.select { |k,v| v == player }.keys
    fork_rows = opponent_free_rows_for_player(state, player).select{ |row| (row & potential_moves).size == 2 && row.include?(potential_move) }
    fork_rows.flatten & opponent_moves
  end

  private

  def creates_connected_moves_for?(row, move, player)
    simulated_state = simulated_move_for(move, player)
    potential_moves = moves_for(simulated_state, player)
    connected_moves?(row, potential_moves)
  end

  def connected_moves?(row, moves)
    moves = row & moves
    (row & moves).size == 2 && two_in_a_row?(row, moves)
  end

  def two_in_a_row?(row, moves)
    row.first(2) == moves || row.last(2) == moves
  end

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

  def rows_where(board_state=@board_state, &block)
    board_state.select &block
  end

  def row_conquerable?(board_state=@board_state, row)
    (row & own_moves(board_state)).size == 2 && (row & opponent_moves(board_state)).size < 1
  end

  def row_defeatable?(board_state=@board_state, row)
    (row & opponent_moves(board_state)).size == 2 && (row & own_moves(board_state)).size < 1
  end

  def row_taken?(board_state=@board_state, row)
    (row & opponent_moves).size == 3 || (row & own_moves).size == 3
  end

  def equal_move_count?(board_state=@board_state)
    own_moves(board_state).size == opponent_moves(board_state).size
  end

end

class InvalidOpponentError < StandardError
end
