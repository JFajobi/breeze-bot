class AdminsController < AuthenticationsController
  layout 'admin_layout'
  def home
    @cars = Car.includes(:reservations).all
    @active_cars = @cars.select{|c|c.occupied?}
    @vacant_cars = @cars.select{|c|c.unoccupied?}
    
    @returned_cars = @cars.select do |c|
      (c.pending_return? && (c.reservations.last.end_date <= Date.today))
    end
  
    @picked_up_cars = @cars.select do |c| 
      next if c.reservations.last.nil? #TODO remove after testing and clean data is in 
      (c.pending_pickup? && (c.reservations.last.start_date <= Date.today))
    end

  end

  def check_fleet_utilization
    start_date = Time.at(params[:start_date].to_i).to_date
    end_date = Time.at(params[:end_date].to_i).to_date
    percent = (StatsService.percent_utilized_within_range(start_date, end_date) * 100).round  
    render text: {:percent => percent, :start => start_date, :end => end_date}.to_json, :status => :ok
  end

  def car_show
    @car = Car.includes({reservations: :member}).find(params[:id])
    reservations = @car.reservations
    @reservation_count = reservations.count 
    @uniq_member_reservations = reservations.uniq_by(&:member)
  end

  def member_show
    @member = Member.includes({reservations: :car}).find(params[:id])
    @reservation_count = @member.reservations.count 
    @uniq_car_reservations = @member.reservations.uniq_by(&:car)
  end

  def check_reservation
    car = Car.find(params[:car_id])
    date = Time.at(params[:time]).to_date
    occupied = car.occupied_on_date?(date)
    render text: {:result => occupied}.to_json, :status => :ok
  end

  def vacate_car
    car = Car.find(params[:id])
    car.vacate
    render :nothing => true, :status => :ok
  end

  def occupy_car
    car = Car.find(params[:id])
    car.occupy

    render :nothing => true, :status => :ok
  end

end