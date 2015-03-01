class ChangeReservationTimeDataType < ActiveRecord::Migration
  def up
    remove_column :reservations, :start_timestamp
    remove_column :reservations, :end_timestamp
    add_column :reservations, :start_date, :date
    add_column :reservations, :end_date, :date
  end

  def down
    add_column :reservations, :start_timestamp, :integer
    add_column :reservations, :end_timestamp, :integer
    remove_column :reservations, :start_date
    remove_column :reservations, :end_date
  end
end
