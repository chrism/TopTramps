class ChangeStashPayoffsToIntergers < ActiveRecord::Migration
  def up
    change_column :people, :wealth, :integer
    change_column :people, :payoffs, :integer
  end

  def down
    change_column :people, :wealth, :decimal
    change_column :people, :payoffs, :decimal
  end
end
