class Reservation < ActiveRecord::Base
  attr_accessible :car_id, :end_timestamp, :member_id, :start_timestamp
end
