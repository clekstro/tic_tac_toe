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
    return center_move if @parser.center_open?
    return opposite_corner_move if @parser.opposite_corner_available?
    return corner_move if @parser.corner_available?
    return edge_move
  end

  private

  def center_move
    return @parser.board.middle
  end

  def corner_move
    return (@parser.open_spaces & @parser.board.corners).sample
  end

  def best_opening_move
    return @parser.board.middle if opponent_opened_in_corner?
    return @parser.corner if opponent_opened_in_middle?
    return @parser.board.middle # opponent opened with edge
  end

  def opposite_corner_move
    @parser.opposite_corner_from(@parser.opponent)
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

  def edge_move
    (@parser.open_spaces & @parser.edges).sample
  end

  def alamo_move
    (@parser.open_spaces & @parser.losing_row).first
  end

  def fork_move
    @parser.open_spaces.detect { |move| @parser.move_creates_fork_for?(move, @parser.computer) }
  end

  def prevent_fork_move
    opponent_forks = @parser.open_spaces.select { |move| @parser.move_creates_fork_for?(move, @parser.opponent) }
    ideal = select_fork_move(opponent_forks, @parser.forks(opponent_forks, @parser.opponent))
    return ideal if ideal
    opponent_forks.sample # fallback to something -- less ideal?
  end


  def select_fork_move(opponent_forks, opponent_fork_moves)
    return two_in_a_row_move_for(opponent_forks, opponent_fork_moves, @parser.computer, @parser.open_spaces)
    # could do another check later...
  end

  def two_in_a_row_move_for(forks, fork_moves, player, moves)
    connected_moves = safe_two_in_a_row(player, moves)
    edge_connections = (connected_moves & @parser.edges)
    edge_move = random_from_non_empty(edge_connections)
    corner_connections = (connected_moves &  @parser.board.corners)
    corner_move = random_from_non_empty(corner_connections)
    return corner_move if (fork_moves & @parser.edges).size == 2
    return forks.sample if (fork_moves & @parser.board.corners).size == 1
    return edge_move
  end

  def safe_two_in_a_row(player, moves)
    moves.select {|move| @parser.makes_two_in_a_row?(move, player)}
  end

  def random_from_non_empty(collection)
    !collection.empty? ? collection.sample : nil
  end

  def random_move
    @parser.random_open_space
  end

end

