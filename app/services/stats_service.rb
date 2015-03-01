class StatsService

  class << self
    def unoccupied_cars_by_date(date)
      Car.all.keep_if{ |car| !car.occupied_on_date?(date)}
    end

    def percent_utilized_within_range(start_date, end_date)
      # fleet_size = Car.where(enrolled_timestamp === occupancy_range).count
      # for simplicity purposes I am assuming the fleet size stays the same
      fleet_size      = Car.all.count      
      occupancy_range = start_date..end_date
      reservation_sum = 0

      total_occupiable_time = get_total_occupiable_time(fleet_size, start_date, end_date)

      # find all reservations that started before the end_date
      potential_reservations = Reservation.where("start_date <= ?", end_date)

      return 0 if potential_reservations.empty?

      # remove any reservation that end before the start_date
      utilized_car_reservations = potential_reservations.keep_if{ |res| res.end_date < start_date}
      altered_reservations      = map_reservation_usage_time(start_date, end_date, utilized_car_reservations)
      total_seconds_utilized    = altered_reservations.each{ |res| reservation_sum += (res.end_date - res.start_date) }

      reservation_sum / total_occupiable_time
    end

    def map_reservation_usage_time(start_date, end_date, reservations)
      reservations.map do |res|
        if res.end_date.nil? or (res.end_date > end_date)
          res.end_date = end_date
        if res.start_date < start_date
          res.start_date = start_date
      end
    end

    # the total amount of time (days) that a fleet of cars can be utilized
    # between two giving dates
    def get_total_occupiable_time(fleet_size, start_date, end_date)
      ((end_date.to_time.to_i - start_date.to_time.to_i)/1.day.to_i) * fleet_size
    end

  end


end
