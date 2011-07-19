class AddResposeCodeToLink < ActiveRecord::Migration
  def change
    add_column :links, :response_code, :integer
  end
end
