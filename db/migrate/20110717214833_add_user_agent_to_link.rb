class AddUserAgentToLink < ActiveRecord::Migration
  def change
    add_column :links, :user_agent_id, :integer
  end
end
