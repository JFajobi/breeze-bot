
def make_admins
  Member.create email: 'jide@gmail.com', password:'123123123', admin: true
  Member.create email: 'charlie@joinbreeze.com', password:'12345678', admin: true
end


def create_random_users
  @members = []
  user_count = 1
  100.times do 
    m = Member.create email: "test_user#{user_count}@gmail.com", password: "12345678"
    user_count += 1
    @members << m
  end
  @member_sliced = @members.each_slice(10).to_a
end

def create_cars
  150.times do 
    c = Car.create make: 'Toyota', model: 'Prius', license_number:"#{rand(99)}b#{rand(99)}r#{rand(10)}"
  end
end

def create_pending_pickups
  @member_sliced[0].each do |m|
    m.create_reservation(Date.today + 10)
  end

  @member_sliced[5].each do |m|
    m.create_reservation(Date.today)
  end
end

def create_occupied_cars
  @member_sliced[1].each do |m|
    m.create_reservation(Date.today - rand(30))
    res = m.reservations.last
    res.car.occupy
  end

  @member_sliced[2].each do |m|
    m.create_reservation(Date.today - rand(15))
    res = m.reservations.last
    res.car.occupy
  end
end

def create_pending_returns
  @member_sliced[3].each do |m|
    m.create_reservation
    res = m.reservations.last
    res.car.occupy
    res.update_attributes end_date: Date.today
    res.car.schedule_return 
  end

  @member_sliced[4].each do |m|
    m.create_reservation
    res = m.reservations.last
    res.car.occupy
    res.update_attributes end_date: Date.today + 13
    res.car.schedule_return 
  end

end

def create_past_reservations
  mems = @members.each_slice(3).to_a
  mems[3].each do |m|
    m.create_reservation(Date.today - 100)
    res = m.reservations.last
    res.car.occupy
    res.update_attributes end_date: Date.today - 60
    res.car.schedule_return 
    res.car.vacate
    res.update_attributes end_date: Date.today - 60
  end

  mems[1].each do |m|
    m.create_reservation(Date.today - 200)
    res = m.reservations.last
    res.car.occupy
    res.update_attributes end_date: Date.today - 101
    res.car.schedule_return 
    res.car.vacate
    res.update_attributes end_date: Date.today - 101
  end

  2.times do 
    mems[1].each do |m|
      m.create_reservation(Date.today - 50)
      res = m.reservations.last
      res.car.occupy
      res.update_attributes end_date: Date.today - 10
      res.car.schedule_return 
      res.car.vacate
      res.update_attributes end_date: Date.today - 10
    end
  end
end

def seed_database
  make_admins
  create_random_users
  create_cars
  create_past_reservations
  create_pending_pickups
  create_occupied_cars
  create_pending_returns
end

seed_database