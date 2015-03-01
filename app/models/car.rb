class Car < ActiveRecord::Base
  attr_accessible :license_number, :make, :model, :status, :enrolled_timestamp

  has_many :members, through: :reservations

  state_machine :status, initial: :unoccupied do
    after_transition :on => :being_serviced, :do => :on_being_serviced

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

  def occupied_on_date?(date)
    # look for all reservations that happened on or before the date specified
    potential_reservations = reservations.where("start_timestamp <= ?", date)
    potential_reservations.each do |res|
      # if the end date is empty, we know the car is still in use
      return true if res.end_date.nil?
      return true if (start_date..end_date) === date
    end
    false
  end

end
