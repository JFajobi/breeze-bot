class Car < ActiveRecord::Base
  attr_accessible :license_number, :make, :model, :status

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

end
