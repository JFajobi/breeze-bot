class Reservation < ActiveRecord::Base
  attr_accessible :car_id, :end_date, :member_id, :start_date

  belongs_to :car
  belongs_to :member
end
