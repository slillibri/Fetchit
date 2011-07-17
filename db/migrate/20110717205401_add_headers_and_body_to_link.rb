class AddHeadersAndBodyToLink < ActiveRecord::Migration
  def change
    add_column :links, :headers, :text
    add_column :links, :body, :text
  end
end
