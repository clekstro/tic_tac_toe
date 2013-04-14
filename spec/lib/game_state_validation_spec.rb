require_relative '../../lib/game_state_validation'

describe GameStateValidation do
  let(:history) { {"A1"=> "X", "A2"=> "X", "A3"=> "O" } }
  context "#invalid?" do
    it "identifies historical inconsistencies" do
      forged_history = {"A1"=> "X", "A2"=> "O", "A3"=> "X" }
      GameStateValidation.new(history, forged_history).valid?.should be_false
    end
    it "detects lack of move" do
      no_move = {"A1"=> "X", "A2"=> "X", "A3"=> "O" }
      GameStateValidation.new(history, no_move).valid?.should be_false
    end

    it "detects more than one move at once" do
      multiple_moves = {"A1"=> "X", "A2"=> "X", "A3"=> "O", "C1" => "X", "C2" => "X" }
      GameStateValidation.new(history, multiple_moves).valid?.should be_false
    end

    it "detects when user attempts to move for opponent" do
      out_of_turn = {"A1"=> "X", "A2"=> "X", "A3"=> "O", "C1" => "O", "C3" => "0"}
      GameStateValidation.new(history, out_of_turn).valid?.should be_false
    end
  end
end
