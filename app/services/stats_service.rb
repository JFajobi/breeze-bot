class StatsService

  class << self
    def unoccupied_cars_by_date(start_timestamp, end_timestamp)

    end

    def percent_utilized_within_range(start_timestamp, end_timestamp)
      # fleet_size = Car.where(enrolled_timestamp === occupancy_range).count
      # for simplicity purposes I am assuming the fleet size stays the same
      fleet_size      = Car.all.count      
      occupancy_range = start_timestamp..end_timestamp
      reservation_sum = 0

      total_occupiable_time = (end_timestamp - start_timestamp) * fleet_size

      # find all reservations that started before the end_timestamp
      potential_reservations = Reservation.where("start_timestamp <= ?", end_timestamp)

      return 0 if potential_reservations.empty?

      # remove any reservation that end before the start_timestamp
      utilized_car_reservations = potential_reservations.keep_if{ |res| res.end_timestamp < start_timestamp}
      altered_reservations      = map_reservation_usage_time(start_timestamp, end_timestamp, utilized_car_reservations)
      total_seconds_utilized    = altered_reservations.each{ |res| reservation_sum += (res.end_timestamp - res.start_timestamp) }

      reservation_sum / total_occupiable_time
    end

    def map_reservation_usage_time(start_timestamp, end_timestamp, reservations)
      reservations.map do |res|
        if res.end_timestamp.nil? or (res.end_timestamp > end_timestamp)
          res.end_timestamp = end_timestamp
        if res.start_timestamp < start_timestamp
          res.start_timestamp = start_timestamp
      end
    end

  end


end
