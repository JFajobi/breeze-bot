class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :status
  # attr_accessible :title, :body

  has_many :reservations
  has_many :cars, through: :reservations


  def create_future_reservation(date)

  end

  def create_immediate_reservation
    
  end

  def find_available_car
    # if we already reserved a car before. Lets try and reserve that same one again
    if !self.reservations.empty?
      past_car = Car.find(self.reservations.last.car_id)      
      return past_car if past_car.unoccupied?
    end

    potential_rentals = Car.where(status: 'unoccupied')
    return false if potential_rentals.empty?
    potential_rentals.first
  end
end
