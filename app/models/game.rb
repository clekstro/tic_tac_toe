class Game < ActiveRecord::Base
  attr_accessible :opponent_id, :player_id, :victor_id, :token, :type, :board_state
  validates :type, presence: true, inclusion: { in: ["HumanGame","ComputerGame"]}
  validates :token, presence: true, uniqueness: true

  after_initialize do
    write_attribute(:token, SecureRandom.hex(64)) unless token
    new_record? ? blank_board : deserialize(board_state)
  end

  before_save do
    serialize(board_state)
  end

  after_save do
    deserialize(board_state)
  end 

  def tie?
    victor_id == 0
  end

  private

  def blank_board
    write_attribute(:board_state, {A1:"", A2:"", A3:"", B1:"", B2:"", B3:"", C1:"", C2:"", C3:""})
  end

  def serialize(board_state)
    write_attribute(:board_state, board_state.to_json)
  end

  def deserialize(board_state)
    write_attribute(:board_state, JSON.parse(board_state))
  end

end

class ComputerGame < Game
end

class HumanGame < Game
end
