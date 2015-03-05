class Car < ActiveRecord::Base
  attr_accessible :license_number, :make, :model, :status, :enrolled_timestamp

  has_many :reservations
  has_many :members, through: :reservations
  after_save :update_dashboard
  after_destroy :update_dashboard

  state_machine :status, initial: :unoccupied do
    after_transition :on => :vacate, :do => :on_vacated
    after_transition :on => :occupy, :do => :update_fleet_utilization_percentage

    event :reserve do
      transition :unoccupied => :pending_pickup
    end

    event :occupy do
      transition [:unoccupied, :pending_pickup] => :occupied
    end

    event :schedule_return do 
      transition :occupied => :pending_return
    end

    # You should be able to change your mind and cancel your order
    event :vacate do
      transition [:pending_pickup, :occupied, :pending_return] => :unoccupied
    end
  end

  def on_vacated
    reservation = self.reservations.last
    # if start_date is after end_date (cancelled reservation and never picked up car)
    reservation.update_attributes end_date: Date.today, active: false
    reservation.destroy if reservation.end_date < reservation.start_date
    update_fleet_utilization_percentage
  end

  def occupied_on_date?(date)
    # look for all reservations that happened on or before the date specified
    potential_reservations = reservations.where("start_date <= ?", date)
    potential_reservations.each do |res|
      # if the end date is empty, we know the car is still in use
      return true if res.end_date.nil?
      # The car is not scheduled to come back until after the requested start date
      return true if res.end_date > date #(start_date..end_date) === date
    end
    false
  end

  # update admin dashboard with new stats
  def update_dashboard
    fleet_size = Car.all.count
    update_fleet_utilization_percentage
    StatsService.update_admin_dashboard('fleet_size', 'current', fleet_size )
  end

  def update_fleet_utilization_percentage
    fleet_utilized_percentage = (StatsService.percent_utilized_within_range(Date.today, Date.tomorrow) * 100).to_i
    StatsService.update_admin_dashboard('fleet_utilized', 'value', fleet_utilized_percentage )
  end

end
