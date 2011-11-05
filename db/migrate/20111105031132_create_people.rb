class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.integer :littlesis_id
      t.string :position
      t.text :summary
      t.string :organization
      t.integer :age
      t.decimal :wealth
      t.integer :friends
      t.integer :height
      t.integer :weight
      t.string :image_url
      t.decimal :donations

      t.timestamps
    end
  end
end
