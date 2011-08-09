class AddColorToLinks < ActiveRecord::Migration
  def change
    add_column :links, :color, :text
  end
end
