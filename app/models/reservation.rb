class Reservation < ActiveRecord::Base
  attr_accessible :car_id, :end_date, :member_id, :start_date, :active

  after_create :reserve_car
  after_save :update_dashboard
  after_destroy :update_dashboard

  belongs_to :car
  belongs_to :member

  def reserve_car
    car.reserve
  end


  # update admin dashboard with new stats
  def update_dashboard
    fleet_utilized_percentage = (StatsService.percent_utilized_within_range(Date.today, Date.tomorrow) * 100).to_i
    checkout_cars = Reservation.includes(:car).where("start_date <= ?", Date.today)
    checkin_cars = Reservation.includes(:car).where("end_date >= ?", Date.today)

    car_actions_count = checkout_cars.keep_if{|r| r.car.pending_pickup?}.count
    car_actions_count+= checkin_cars.keep_if{|r| r.car.pending_return?}.count

    StatsService.update_admin_dashboard('attention', 'current', car_actions_count )
    StatsService.update_admin_dashboard('fleet_utilized', 'value', fleet_utilized_percentage )
    
  end

end
