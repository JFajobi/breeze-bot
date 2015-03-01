class Reservation < ActiveRecord::Base
  attr_accessible :car_id, :end_timestamp, :member_id, :start_timestamp

  belongs_to :car
  belongs_to :member
end
