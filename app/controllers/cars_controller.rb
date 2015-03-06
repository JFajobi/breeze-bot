class CarsController < AuthenticationsController
  layout 'member_layout'
  def reserve_car
    member = Member.find params[:id]
    date = Time.at(params[:time].to_i).to_date
    reserved = member.create_reservation(date)
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

  def return_car
    member = Member.find params[:id]
    date = Time.at(params[:time].to_i).to_date
    reservation = member.reservations.last
    reservation.update_attributes :end_date => date
    reservation.car.schedule_return
    redirect_to pending_return_path 
  end

  def end_reservation
    Car.find(params[:car_id]).vacate
    redirect_to find_car_path , :alert => "Your reservation has been canceled" 
  end

  def pending_pickup
    reservation  = current_member.reservations.last
    @car         = reservation.car
    @date        = reservation.start_date

    render 'member/pickup'
  end

  def occupied
    @member = current_member.id
    
    render 'member/return'
  end

  def pending_return
    reservation = current_member.reservations.last
    @display_sentence = map_day_value ((reservation.end_date.to_time - Date.today.to_time) / 1.day).round

    render 'member/pending_return'
  end

  private

  def map_day_value(days)
    case 
    when days == 0
      "Don't forget to turn in your car, it's due today"
    when days < 0
      "A Breeze-Bot professional is checking in your car, once done you can rent another"
    else
      "You have #{days} left in your rental"
    end
  end

end