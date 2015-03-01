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


  def create_reservation(date=nil)
    date = date || Date.today
    return if book_previous_car(date)
    return if book_vacant_car(date)
    return if book_pending_car(date)
    false
  end


  def find_available_car
    # if we already reserved a car before. Lets try and reserve that same one again
    if !self.reservations.empty?
      past_car = Car.find(self.reservations.last.car_id)      
      return past_car if past_car.unoccupied?
    end

    potential_rentals = Car.all.where(status: 'unoccupied')

    return false if potential_rentals.empty?
    potential_rentals.first
  end


  def book_previous_car(date)
    if !self.reservations.empty?
      past_car = Car.find(self.reservations.last.car_id)      
      if past_car.unoccupied? || past_car.occupied_on_date(date)
        self.reservations.create car_id: past_car.id, start_date: date 
      end
    end 
    false   
  end

  def book_vacant_car(date)
    @potential_cars = Car.all.where(status: [:pending_return, :unoccupied])
    return false if @potential_cars.empty?
    unoccupied_cars = @potential_cars.keep_if{ |car| car.status == 'unoccupied'}
    return false if unoccupied_cars.empty?
    self.reservations.create car_id: unoccupied_cars.first.id, start_date: date 
  end

  def book_pending_car(date)
    return false if @potential_cars.empty?
    @potential_cars.each do |car|
      next if car.occupied_on_date?(date)
      return self.reservations.create car_id: car.id, start_date: date 
    end
    false
  end





end
