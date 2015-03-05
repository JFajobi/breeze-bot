class ActionsController < AuthenticationsController
  def determine_view
    return redirect_to admin_path if current_member.admin?

    reservation = current_member.reservations.last
    
    
    return redirect_to find_car_path if reservation.nil? || !reservation.active

    case reservation.car.status
    when 'pending_pickup'
       return redirect_to pending_pickup_path
    when 'occupied'
       return redirect_to driving_path
    when 'pending_return'
       return redirect_to pending_return_path
    end

  end



end