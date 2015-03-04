class CarsController < AuthenticationsController

  def reserve_car
    member = Member.find params[:id]
    date = Time.at(params[:time].to_i).to_date
    reserved = member.create_reservation(date)
    binding.pry
    return redirect_to pending_pickup_path if reserved
    redirect_to find_car_path, :alert => "Sorry there are no cars available on #{date}" 
  end

  def find_car
    @member = current_member.id
    render 'member/no_car'
  end

  def no_car
    @member = current_member.id
    render 'member/no_car'
  end

  def end_reservation
    Car.find(params[:car_id]).vacate
    redirect_to find_car_path , :alert => "Your reservation has been canceled" 
  end

  def pending_pickup
    reservation = current_member.reservations.last
    @car         = reservation.car
    @license     = @car.license_number
    @model       = @car.model
    @make        = @car.make
    @date        = reservation.start_date
    render 'member/pickup'
  end

  def occupied
    render 'member/return'
  end

  def pending_return
    render 'member/pending_return'
  end

end