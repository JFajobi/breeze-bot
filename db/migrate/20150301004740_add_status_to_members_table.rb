class AddStatusToMembersTable < ActiveRecord::Migration
  def up
    add_column :members, :status, :string
  end

  def down
    remove_column :members, :status
  end
end
