class DropAgentIdFromUserAgent < ActiveRecord::Migration
  def up
    remove_column :user_agents, :agent_id
  end

  def down
  end
end
