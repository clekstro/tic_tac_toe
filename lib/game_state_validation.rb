class GameStateValidation
  # Check that history is intact, one and only one move made in proper order
  def initialize(saved_state, passed_state)
    @saved_state = saved_state
    @passed_state = passed_state
  end

  def valid?
    !invalid?
  end

  private

  def invalid?
    forged_history? || no_move? || multiple_moves? || out_of_turn?
  end

  def forged_history?
    history = pairs_with_values(@saved_state)
    claimed_history = @passed_state.select { |k,v| history.key?(k) }
    history != claimed_history
  end

  def no_move?
    previous_moves >= current_moves
  end

  def multiple_moves?
    current_moves > (previous_moves + 1)
  end

  def previous_moves
    @previous_moves ||= amount_with_values(@saved_state)
  end

  def current_moves
    @current_moves ||= amount_with_values(@passed_state)
  end

  def out_of_turn?
    x_turns = @saved_state.select { |k,v| v == "X" }.size
    o_turns = @passed_state.select { |k,v| v == "O" }.size
    (o_turns > x_turns) || (x_turns > o_turns + 1)
  end

  def pairs_with_values(hash)
    return hash.reject { |k,v| v.blank? }
  end

  def amount_with_values(hash)
    pairs_with_values(hash).size
  end

end
