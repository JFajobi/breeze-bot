class ActionsController < AuthenticationsController
  def determine_view
    return admin_view if current_member.admin?
    begin
      reservation = current_member.reservations.last
    rescue
      return redirect_to find_car_path
    end
    return no_car_view if !reservation.active

    case reservation.car.status
    when 'pending_pickup'
       return redirect_to pending_pickup_path
    when 'occupied'
       return redirect_to occupied_path
    when 'pending_return'
       return redirect_to pending_return_path
    end

  end


  def admin_view
    render 'admin/home'
  end


end