class ConvertBoardStateTextToBlob < ActiveRecord::Migration
  def up
    remove_column :games, :board_state
    add_column :games, :board_state, :blob
  end

  def down
  end
end
