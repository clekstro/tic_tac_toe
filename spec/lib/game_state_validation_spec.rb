require_relative '../../lib/game_state_validation'

describe GameStateValidation do
  let(:history) do
    {
      "A1"=>"X",
      "A2"=>"X",
      "A3"=>"O" 
    }
  end
  context "#invalid?" do
    it "identifies historical inconsistencies" do
      forged_history = {
        "A1"=>"X",
        "A2"=>"O",
        "A3"=>"X"
      }
      GameStateValidation.new(history, forged_history).valid?.should be_false
    end

    it "detects lack of move" do
      GameStateValidation.new(history, history).valid?.should be_false
    end

    it "detects more than one move at once" do
      multiple_moves = {
        "A1"=>"X",
        "A2"=>"X",
        "A3"=>"O",
        "C1"=>"X",
        "C2"=>"X"
      }
      GameStateValidation.new(history, multiple_moves).valid?.should be_false
    end

    it "detects out of turn move" do
      x_moves_again = {
        "A1"=>"X",
        "A2"=>"X",
        "A3"=>"O",
        "B1"=>"X"
      } 
      GameStateValidation.new(history, x_moves_again).valid?.should be_false
    end

  end
end
