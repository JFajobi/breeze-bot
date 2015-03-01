class Reservation < ActiveRecord::Base
  attr_accessible :car_id, :end_date, :member_id, :start_date

  after_create :reserve_car

  belongs_to :car
  belongs_to :member

  def reserve_car
    car.reserve
  end
end
