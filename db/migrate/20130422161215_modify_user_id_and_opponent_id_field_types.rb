class ModifyUserIdAndOpponentIdFieldTypes < ActiveRecord::Migration
  def up
    change_column :games, :opponent_id, :string
    change_column :games, :player_id, :string
  end

  def down
    change_column :games, :opponent_id, :integer
    change_column :games, :player_id, :integer
  end
end
