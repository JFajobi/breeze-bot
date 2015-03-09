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

  def days_left_in_reservation
    return if end_date.nil? || !active
    days = end_date - Date.today
    days < 0 ? 0 : days
  end

  def days_to_pickup
    return 0 if start_date >= Date.today
    start_date - Date.today
  end

  def self.get_actionable_reservation_count
    checkout_cars = Reservation.includes(:car).where("start_date <= ?", Date.today)
    checkin_cars = Reservation.includes(:car).where("end_date <= ?", Date.today)

    car_actions_count = checkout_cars.select{|r| r.car.pending_pickup? && r.active}.count
    car_actions_count += checkin_cars.select{|r| r.car.pending_return? && r.active}.count
  end
  
  # update admin dashboard with new stats
  def update_dashboard
    fleet_utilized_percentage = (StatsService.percent_utilized_within_range(Date.today, Date.tomorrow) * 100).to_i
    car_actions_count = Reservation.get_actionable_reservation_count

    StatsService.update_admin_dashboard('attention', 'current', car_actions_count )
    StatsService.update_admin_dashboard('fleet_utilized', 'value', fleet_utilized_percentage )
    
  end

end
