class AddActiveColumnToReservationsTable < ActiveRecord::Migration
  def up
    add_column :reservations, :active, :boolean, default: true
  end

  def down
    remove_column :reservations, :active
  end
end
