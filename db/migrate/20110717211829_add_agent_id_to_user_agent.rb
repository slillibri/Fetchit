class AddAgentIdToUserAgent < ActiveRecord::Migration
  def change
    add_column :user_agents, :agent_id, :string
  end
end
