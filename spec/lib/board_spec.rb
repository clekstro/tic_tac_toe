require_relative '../../lib/board.rb'

describe Board do
  let(:board) { Board.new }
  subject { board }

  it{ should respond_to(:blank) }
  its(:middle) { should == "B2" }
  its(:corners) { should == ["A1", "A3", "C1", "C3"] }

  context "layout" do
    it "has 8 total rows" do
      board.all_rows.count.should == 8
    end

    it "has 3 vertical rows" do
      board.vertical_rows.count.should == 3
    end
    
    it "has 3 horizontal rows" do
      board.horizontal_rows.count.should == 3
    end

    it "has 2 diagonal rows" do
      board.diagonal_rows.count.should == 2
    end
  end

end
