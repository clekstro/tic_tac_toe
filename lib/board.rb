class Board
  attr_accessor :board_state

  def initialize(board_state=blank)
    @board_state = board_state
  end

  def blank
     {"A1"=>"", "A2"=>"", "A3"=>"",
      "B1"=>"", "B2"=>"", "B3"=>"",
      "C1"=>"", "C2"=>"", "C3"=>""}
  end

  def vertical_rows
    [["A1", "B1", "C1"], ["A2", "B2", "C2"], ["A3", "B3", "C3"]]
  end

  def horizontal_rows
    [["A1", "A2", "A3"], ["B1", "B2", "B3"], ["C1", "C2", "C3"]]
  end

  def diagonal_rows
    [["A1", "B2", "C3"], ["A3", "B2", "C1"]]
  end

  def all_rows
    (vertical_rows.concat(horizontal_rows)).concat(diagonal_rows)
  end

  def middle
    "B2"
  end

  def corners
    ["A1","A3","C1","C3"]
  end

  def opposite_corner(corner)
    case corner
    when "A1" then "C3"
    when "A3" then "C1"
    when "C1" then "A3"
    when "C3" then "A1"
    end
  end

end
