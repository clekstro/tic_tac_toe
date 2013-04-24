require_relative "../../lib/computer_strategy"
require_relative "../../lib/board_parser"
require_relative "../../lib/board"

describe ComputerStrategy do
  let(:board) { Board.new }
  let(:parser_with_o_opponent) { BoardParser.new(board: board, opponent: "O") }
  let(:x_strategy) { ComputerStrategy.new(parser_with_o_opponent) }
  let(:o_strategy) { ComputerStrategy.new(BoardParser.new({board: board})) }

  subject { o_strategy }
  it{ should respond_to(:best_move) }

  context "opening_moves" do
    it "chooses middle if opponent opens in corner" do
      board.board_state["A1"] = "X"
      subject.best_move.should == "B2"
    end
  end
  context "with opponent X" do
    it "responds properly to X's opening move in corner" do
      board.board_state["A1"] = "X"
      subject.parser.opening_move?.should be_true
      subject.best_move.should == "B2"
    end

    it "responds properly to X's opening move in middle" do
      board.board_state["B2"] = "X"
      ["A1","A3","C1","C3"].should include subject.best_move
    end

    it "can win" do
      board.board_state["A1"] = "O"
      board.board_state["A3"] = "O"
      subject.best_move.should == "A2"
    end

    it "prevents a loss" do
      board.board_state["A1"] = "X"
      board.board_state["B2"] = "X"
      subject.best_move.should == "C3"
    end

    it "chooses victory when possible" do
      board.board_state["A1"] = "X"
      board.board_state["A2"] = "X"
      board.board_state["B1"] = "X"
      board.board_state["C1"] = "O"
      board.board_state["C2"] = "O"
      subject.best_move.should == "C3"
    end

    it "does not get stuck" do
      board.board_state["A1"] = "X"
      board.board_state["B2"] = "O"
      board.board_state["C1"] = "X"
      board.board_state["B1"] = "O"
      board.board_state["B3"] = "X"
      subject.best_move.should be
    end
  end
  context "no wasted moves" do
    it "does not waste move" do
      board.board_state["B3"] = "X"
      board.board_state["B2"] = "O"
      board.board_state["C1"] = "X"
      ["A2","B1"].should_not include subject.best_move
    end
    it "does not waste move" do
      board.board_state["A1"] = "X"
      board.board_state["B2"] = "O"
      board.board_state["C2"] = "X"
      subject.best_move.should_not == "A2"
    end
  end
  context "forking" do
    it "successfully forks if possible" do
      board.board_state["C3"] = "X"
      board.board_state["B2"] = "O"
      board.board_state["A1"] = "X"
      board.board_state["A3"] = "O"
      ["C1", "C2"].should include x_strategy.best_move
    end
    it "defends against a fork" do
      board.board_state["B1"] = "X"
      board.board_state["B2"] = "O"
      board.board_state["C3"] = "X"
      subject.best_move.should_not == "A3"
      ["C1","C2"].should include subject.best_move
    end
  end
end
