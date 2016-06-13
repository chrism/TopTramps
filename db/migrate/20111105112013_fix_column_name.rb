class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :people, :position, :description
    rename_column :people, :donations, :payoffs
  end
end
