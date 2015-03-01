class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :status
  # attr_accessible :title, :body

  has_many :cars, through: :reservations


  # TODO: decide whether a user should be stateful at all
  # state_machine :status, initial: :unoccupied do
  #   after_transition :on => :being_serviced, :do => :on_being_serviced

  #   event :reserve do
  #     transition :unoccupied => :pending_pickup
  #   end

  #   event :occupy do
  #     transition [:unoccupied, :pending_pickup] => :occupied
  #   end

  #   event :schedule_return do 
  #     transition :occupied => :pending_return
  #   end

  #   # You should be able to change your mind and cancel your order
  #   event :vacate do
  #     transition [:pending_pickup, :occupied, :pending_return] => :unoccupied
  #   end

  # end

end
