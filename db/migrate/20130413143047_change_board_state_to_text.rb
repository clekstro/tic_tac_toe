class ChangeBoardStateToText < ActiveRecord::Migration
  def up
    remove_column :games, :board_state
    add_column :games, :board_state, :text
  end

  def down
  end
end
