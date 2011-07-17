class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.string :hash
      t.boolean :processed

      t.timestamps
    end
  end
end
