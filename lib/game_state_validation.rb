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
    security_risk? || forged_history? || no_move? || multiple_moves? || out_of_turn?
  end

  def security_risk?
    invalid_keys? || invalid_values?
  end

  def invalid_keys?
    @passed_state.keys != @saved_state.keys
  end

  def invalid_values?
    @passed_state.values.any? { |v| !v.match(/[XO]{1}|\A\Z/) }
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
    x_out_of_turn? || o_out_of_turn?
  end

  def o_out_of_turn?
    value_delta(@saved_state, "O", "X") > 0
  end

  def x_out_of_turn?
    prev = value_delta(@saved_state, "X", "O")
    curr = value_delta(@passed_state, "X", "O")
    prev + curr >= 2
  end

  def pairs_with_values(hash)
    return hash.reject { |k,v| v.blank? }
  end

  def amount_with_values(hash)
    pairs_with_values(hash).size
  end

  def value_delta(hash, val1, val2)
    v1_cnt = hash.select { |k,v| v == val1 }.size
    v2_cnt = hash.select { |k,v| v == val2 }.size
    v1_cnt - v2_cnt
  end

end
