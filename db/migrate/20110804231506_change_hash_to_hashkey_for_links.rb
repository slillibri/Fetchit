class ChangeHashToHashkeyForLinks < ActiveRecord::Migration
  def up
    rename_column :links, :hash, :hashkey
  end

  def down
  end
end