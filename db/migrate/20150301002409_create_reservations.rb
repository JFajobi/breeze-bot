class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :start_timestamp
      t.integer :end_timestamp
      t.integer :member_id
      t.integer :car_id

      t.timestamps
    end
  end
end
