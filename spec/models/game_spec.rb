require 'spec_helper'

describe Game do
  let(:game) { Game.new({type: "ComputerGame"}) }
  it "is invalid without type" do
    game.type = nil
    game.should_not be_valid
  end

  it "is invalid if type subclass non-existent" do
    game.should be_valid
    game.type = "ComputerGame"
    game.should be_valid
    game.type = "XYZGame"
    game.should_not be_valid
  end

  it "is invalid without existing unique token" do
    game.token = nil
    game.should_not be_valid
    game.token = '2048ac7125aafbaaa3ff'
    game.save
    new_game = Game.new({token: '2048ac7125aafbaaa3ff', type: "HumanGame"})
    new_game.should_not be_valid
  end

  it "persists its board_state as retrievable serialized JSON" do
    game.save
    game.board_state.should be_a_kind_of Hash
  end
end
