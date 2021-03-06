class StatsService

  class << self

    def unoccupied_cars_by_date(date)
      Car.all.keep_if{ |car| !car.occupied_on_date?(date)}
    end

    def update_admin_dashboard(widget_id, data_id, data_value)
      HTTParty.post(BreezeBot::Application.config.dashboard_url + "/#{widget_id}",
        :body => { "auth_token" => "YOUR_AUTH_TOKEN", "#{data_id}" => "#{data_value}" }.to_json)
    end

    def percent_utilized_within_range(start_date, end_date)
      # fleet_size = Car.where(enrolled_timestamp === occupancy_range).count
      # for simplicity purposes I am assuming the fleet size stays the same
      fleet_size      = Car.all.count      
      reservation_sum = 0

      total_occupiable_time = get_total_occupiable_time(fleet_size, start_date, end_date)
      
      # find all reservations that started before the end_date
      potential_reservations = Reservation.where("start_date <= ?", end_date)

      return 0 if potential_reservations.empty?

      # remove any reservation that end before the start_date
      utilized_car_reservations = potential_reservations.select{ |res| res.end_date.nil? || (res.end_date < start_date) }
      altered_reservations      = map_reservation_usage_time(start_date, end_date, utilized_car_reservations)
      
      # the total amount of time (days) that a fleet of cars were being utilized
      # JS datepicker library or something is not returning full complete days. So convert to float adn round
      # TODO fix
      altered_reservations.each{ |res| reservation_sum += ((res.end_date.to_time.to_i.to_f - res.start_date.to_time.to_i.to_f)/1.day.to_i.to_f).round}

      reservation_sum.to_f / total_occupiable_time.to_f
      
    end

    # we only want to count the time a car was reserved inbetween our search window
    # so if a reservation started before, or ends after (no set end date) we adjust 
    def map_reservation_usage_time(start_date, end_date, reservations)
     reservations.map do |res|

        if res.end_date.nil? or (res.end_date > end_date)
          res.end_date = end_date
        end

        if res.start_date < start_date
          res.start_date = start_date
        end
      end
      reservations
    end

    # the total amount of time (days) that a fleet of cars can be utilized
    # between two giving dates
    def get_total_occupiable_time(fleet_size, start_date, end_date)
      time = ((end_date.to_time.to_i - start_date.to_time.to_i)/1.day.to_i) * fleet_size

      time == 0 ? fleet_size : time

    end

  end


end
