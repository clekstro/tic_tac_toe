class AddBoardStateToGames < ActiveRecord::Migration
  def change
    add_column :games, :board_state, :string
  end
end
