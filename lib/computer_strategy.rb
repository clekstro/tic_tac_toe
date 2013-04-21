require_relative 'board'

class ComputerStrategy
  attr_accessor :parser

  def initialize(parser)
    @parser = parser
  end

  def best_move
    return victorious_move if @parser.victory_iminent?
    return alamo_move if @parser.defeat_iminent?
    return fork_move if @parser.fork_possible_for?(@parser.computer)
    return prevent_fork_move if @parser.fork_possible_for?(@parser.opponent)
    return best_opening_move if @parser.opening_move?
    return side_edge_move if @parser.secondary_move?
    return random_move
  end

  private

  def best_opening_move
    return @parser.board.middle if opponent_opened_in_corner?
    return @parser.corner if opponent_opened_in_middle?
    return @parser.board.middle # opponent opened with edge
  end
  
  def opponent_opened_in_corner?
    @parser.opening_move? && @parser.board.corners.include?(@parser.opponent_moves.first)
  end

  def opponent_opened_in_middle?
    @parser.opening_move? && (@parser.opponent_moves.first == @parser.board.middle)
  end

  def victorious_move
    (@parser.open_spaces & @parser.winning_row).first
  end

  def side_edge_move
    (@parser.open_spaces & @parser.edges).sample
  end

  def alamo_move
    (@parser.open_spaces & @parser.losing_row).first
  end

  def fork_move
    @parser.open_spaces.detect { |move| @parser.move_creates_fork_for?(move, @parser.computer) }
  end

  def prevent_fork_move
    potential_moves = @parser.open_spaces.select { |move| @parser.move_creates_fork_for?(move, @parser.opponent) }
    if (@parser.board.corners & potential_moves).size >= 1
      side_edge_move
    end
  end

  def random_move
    @parser.random_open_space
  end

end

