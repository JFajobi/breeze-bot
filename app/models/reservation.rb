class Reservation < ActiveRecord::Base
  attr_accessible :car_id, :end_date, :member_id, :start_date

  after_create :reserve_car
  after_create :update_dashboard

  belongs_to :car
  belongs_to :member

  def reserve_car
    car.reserve
  end

  # update admin dashboard with new stats
 def update_dashboard
    fleet_utilized_percentage = (StatsService.percent_utilized_within_range(Date.today, Date.tomorrow) * 100).to_i

    StatsService.update_admin_dashboard('fleet_utilized', 'value', fleet_utilized_percentage )
    
  end

end
