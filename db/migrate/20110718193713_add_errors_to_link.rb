class AddErrorsToLink < ActiveRecord::Migration
  def change
    add_column :links, :error, :text
  end
end
