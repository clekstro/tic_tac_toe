require_relative '../../lib/board_parser'
require_relative '../../lib/board'

describe BoardParser do
  let(:invalid_parser) { BoardParser.new({opponent: "S"}) }
  it{ should raise_error }

  let(:parser) { BoardParser.new }
  subject { parser }

  context "board parsing" do
    it "detects all open spaces" do
      parser.open_spaces.should == parser.board_state.keys
    end

    it "identifies opening move" do
      parser.board_state["A1"] = "X"
      parser.opening_move?.should be_true
    end

    it "finds own moves" do
      parser.board_state["A1"] = "X"
      parser.board_state["C1"] = "O"
      parser.own_moves.should == ["C1"]
    end

    it "finds opponent moves" do
      parser.board_state["A1"] = "X"
      parser.board_state["C3"] = "X"
      parser.board_state["B3"] = "O"
      parser.opponent_moves.should == ["A1", "C3"]
    end

    it "finds opponent free rows" do
      parser.board_state["A1"] = "X"
      parser.board_state["B2"] = "X"
      parser.board_state["C3"] = "X"
      parser.opponent_free_rows.should == []
    end

    it "senses horizontal row threat" do
      parser.board_state["A1"] = "X"
      parser.board_state["A3"] = "X"
      parser.defeat_iminent?.should be_true
    end

    it "senses vertical row threat" do
      parser.board_state["A1"] = "X"
      parser.board_state["C1"] = "X"
      parser.defeat_iminent?.should be_true
    end

    it "senses diagonal row threat" do
      parser.board_state["A1"] = "X"
      parser.board_state["C3"] = "X"
      parser.defeat_iminent?.should be_true
      parser.board_state["B2"] = "0"
      parser.defeat_iminent?.should be_false
    end

    it "senses horizontal victory chance" do
      parser.board_state["A1"] = "O"
      parser.board_state["A3"] = "O"
      parser.victory_iminent?.should be_true
      parser.board_state["A2"] = "X"
      parser.victory_iminent?.should be_false
    end

    it "senses vertical victory chance" do
      parser.board_state["A1"] = "O"
      parser.board_state["C1"] = "O"
      parser.victory_iminent?.should be_true
      parser.board_state["B1"] = "X"
      parser.victory_iminent?.should be_false
    end

    it "senses diagonal victory chance" do
      parser.board_state["A1"] = "O"
      parser.board_state["C3"] = "O"
      parser.victory_iminent?.should be_true
      parser.board_state["B2"] = "X"
      parser.victory_iminent?.should be_false
    end

    it "senses chance to fork" do
      parser.board_state["C3"] = "X"
      parser.board_state["B3"] = "O"
      parser.board_state["B2"] = "X"
      parser.board_state["A1"] = "O"
      parser.fork_possible_for?("X").should be_true
    end

    it "senses opponent fork" do
      parser.board_state["C3"] = "X"
      parser.board_state["B2"] = "O"
      parser.board_state["A1"] = "X"
      parser.board_state["A3"] = "O"
      parser.fork_possible_for?("X").should be_true
    end

    it "senses if move creates fork for player" do
      parser.board_state["C3"] = "X"
      parser.board_state["B2"] = "O"
      parser.board_state["A1"] = "X"
      parser.board_state["A3"] = "O"
      parser.move_creates_fork_for?("A3", "X").should be_false
      parser.move_creates_fork_for?("C1", "X").should be_true
    end

    it "senses if player move will enable fork in next move" do
      parser.board_state["C3"] = "X"
      parser.board_state["B2"] = "O"
      parser.board_state["B1"] = "X"
      parser.move_enables_fork_for?("A3", "X").should be_true
    end

    it "knows when game is over" do
      parser.board_state["A3"] = "X"
      parser.board_state["C3"] = "O"
      parser.board_state["A1"] = "X"
      parser.board_state["C2"] = "O"
      parser.game_over?.should be_false
      parser.board_state["A2"] = "X"
      parser.game_over?.should be_true
    end

    it "retrieves spaces of winning row as array" do
      parser.board_state["A1"] = "X"
      parser.winning_row_spaces.should == []
      parser.board_state["A2"] = "X"
      parser.board_state["A3"] = "X"
      parser.winning_row_spaces.should == ["A1", "A2", "A3"]
    end

    it "recognizes wasting moves" do
      parser.board_state["B3"] = "X"
      parser.board_state["B2"] = "O"
      parser.board_state["C1"] = "X"
      parser.wasteful_moves.should include "B1"
    end

    it "detects opponent in corner" do
      parser.board_state["A2"] = "X"
      parser.opponent_in_corner?.should be_false
      parser.board_state["A1"] = "X"
      parser.opponent_in_corner?.should be_true
    end

    it "detects two in a row" do
      parser.board_state["A1"] = "X"
      parser.two_in_a_row?("C1", "X").should be_false
      parser.two_in_a_row?("B1", "X").should be_true
    end

    it "detects whose turn it is" do
      parser.board_state["A1"] = "X"
      parser.player_turn?("X").should be_false
    end
  end
end
